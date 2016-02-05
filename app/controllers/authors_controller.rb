class AuthorsController < ApplicationController

	include BraintreeHelper

	before_action :authenticate_user!
	before_action :only_allow_current_user

	def edit
		if current_user.author?
			@author = current_user
		else
			@author = Author.new
		end
	end

	def update
		# @author = Author.new(author_params)
		user = current_user
		trimmed_author_params = author_params
		date_of_birth = trimmed_author_params.delete(:date_of_birth) #remove date_of_birth from author_params
		routing_number = trimmed_author_params.delete(:routing_number) #remove routing_number from author_params
		account_number = trimmed_author_params.delete(:account_number) #remove account_number from author_params

		user.assign_attributes(trimmed_author_params)
		@author = user #for rerendering 'edit'
		@author.date_of_birth = date_of_birth
		if user.valid?
			braintree_call = save_author_to_braintree(user, date_of_birth, routing_number, account_number) #braintree helpers
			if braintree_call.success?
				puts "AUTHOR SAVED TO BRAINTREE"
				puts "braintree call is #{braintree_call}"
				if user.save	
					flash[:success] = "Great.  Now it's time to upload your first document!"
					puts "user saved to DB"
					redirect_to new_document_path
				else #in theory, with client side validations, cannot get here
					@author.date_of_birth = params[:author][:date_of_birth] if params[:author]
					@author.date_of_birth = params[:user][:date_of_birth] if params[:user]					
					flash.now[:error] = "Something went wrong.  Please check the errors below."
					@errors = user.errors
					puts "in NEVER SHOULD BE IN HERE AREA"
					render 'edit'
				end
			else
				@author.date_of_birth = params[:author][:date_of_birth] if params[:author]
				@author.date_of_birth = params[:user][:date_of_birth] if params[:user]						
				flash.now[:error] = "Something went wrong.  Please check the errors below."
				@braintree_errors = braintree_call.errors
				puts "AUTHOR TO BRAINTREE FAILED"
				puts "braintree_call.errors are #{braintree_call.errors.inspect}"
				render 'edit'
			end
		else
			@author.date_of_birth = params[:author][:date_of_birth] if params[:author]
			@author.date_of_birth = params[:user][:date_of_birth] if params[:user]	
			@errors = user.errors
			flash.now[:error] = "Something went wrong.  Please check the errors below."
			puts "save did not work because user is invalid"
			puts "author errors: #{user.errors.inspect}"
			render 'edit'
		end
	end

	private

	def only_allow_current_user
		puts "params[:id] are #{params['id']}"
		puts "current_user id is #{current_user.id}"
		if params[:id].to_i != current_user.id
			flash[:error] = "You do not have access privelages to this page."
			redirect_to root_path
		end
	end

	def author_params
		if params[:author]
			c = params.require(:author).permit(:type, :first_name, :last_name, :date_of_birth, :description, :street_address, :locality, :region, :postal_code, :account_number, :routing_number)
		else
			c = params.require(:user).permit(:type, :first_name, :last_name, :date_of_birth, :description, :street_address, :locality, :region, :postal_code, :account_number, :routing_number)
		end
		puts "c is #{c.inspect}"
		date_of_birth = c[:date_of_birth]
		c[:date_of_birth] = Date.strptime(date_of_birth, '%m/%d/%Y')
		puts "c after bday thing is #{c.inspect}"
		c
	end
end
