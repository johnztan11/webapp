class TransactionsController < ApplicationController

	include BraintreeHelper

	def create
		@document = Document.find(transaction_params[:document_id])
		@transaction = Transaction.new(transaction_params)
		@transaction.buyer = current_user
		@transaction.author = @document.author
		payment_method_nonce = params[:payment_method_nonce]
<<<<<<< HEAD
		@non_user_email = transaction_params[:non_user_email] if transaction_params[:non_user_email]
=======
>>>>>>> d09c65119222ff934cab626b7424472ced92d7f9
		
		if @transaction.valid?
			braintree_call = create_transaction(@document, payment_method_nonce) #from BrainTree Helper
		
			if braintree_call.success?
				puts "transaction a success \n"
				puts "transaction is #{braintree_call}"
				flash[:success] = "You have purchased #{@document.title}"
<<<<<<< HEAD
				puts "the params just before save are #{transaction_params.inspect}".blue
				@transaction.save

				if @non_user_email
					redirect_to document_path(@document, downloaded_document: "yes")
				else
					redirect_to @document
				end
=======
				@transaction.save
				redirect_to @document
>>>>>>> d09c65119222ff934cab626b7424472ced92d7f9
			else
				flash[:danger] = "Your transaction failed because #{braintree_call.errors}"
				puts "braintree_call FAILED \n"
				puts "braintree_call is #{braintree_call.errors}\n"
				puts "braintree_call is #{braintree_call.inspect}"
				redirect_to @document
			end
		else
			flash[:danger] = flash[:danger] = "Your transaction failed because #{@transaction.errors.full_messages}"
			redirect_to @document
		end
	end

	private

	def transaction_params
<<<<<<< HEAD
		params.require(:transaction).permit(:document_id, :non_user_email)
=======
		params.require(:transaction).permit(:document_id)
>>>>>>> d09c65119222ff934cab626b7424472ced92d7f9
	end
end
