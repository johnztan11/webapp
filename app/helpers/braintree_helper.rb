module BraintreeHelper
	def save_author_to_braintree(author, date_of_birth, routing_number, account_number)

		merchant_account = find_merchant_account(author) #method is below
		if merchant_account
			merchant_account_params = {
			  :individual => {
			    :first_name => author.first_name,
			    :last_name => author.last_name,
			    :email => current_user.email,
			    :date_of_birth => date_of_birth,
			    :address => {
			      :street_address => author.street_address,
			      :locality => author.locality,
			      :region => author.region,
			      :postal_code => author.postal_code
			    }
			  },
			  :funding => {
			    :descriptor => "#{author.first_name} #{author.last_name} | #{current_user.email}",
			    :destination => Braintree::MerchantAccount::FundingDestination::Bank,
			    :account_number => account_number,
			    :routing_number => routing_number
			  }
			}
			result = Braintree::MerchantAccount.update("#{current_user.id}", merchant_account_params)
		else
			merchant_account_params = {
			  :individual => {
			    :first_name => author.first_name,
			    :last_name => author.last_name,
			    :email => current_user.email,
			    :date_of_birth => date_of_birth,
			    :address => {
			      :street_address => author.street_address,
			      :locality => author.locality,
			      :region => author.region,
			      :postal_code => author.postal_code
			    }
			  },
			  :funding => {
			    :descriptor => "#{author.first_name} #{author.last_name} | #{current_user.email}",
			    :destination => Braintree::MerchantAccount::FundingDestination::Bank,
			    :account_number => account_number,
			    :routing_number => routing_number
			  },
			  :tos_accepted => true,
			  :master_merchant_account_id => ENV['BRAINTREE_MASTER_MERCHANT_ACCOUNT_ID'],
			  :id => "#{current_user.id}"
			}
			result = Braintree::MerchantAccount.create(merchant_account_params)
		end
	end

	def create_transaction(document, payment_method_nonce)
		result = Braintree::Transaction.sale(
		  :amount => "#{document.price}",
		  :merchant_account_id => "#{document.author.id}",
		  :payment_method_nonce => params[:payment_method_nonce],
		  :service_fee_amount => "1.00",
		  :options => {
		    :submit_for_settlement => true
		  }
		)
	end

	protected

	def find_merchant_account(author)
 		begin
			merchant_account = Braintree::MerchantAccount.find(author.id)
			puts "the merchant account is #{merchant_account}"
			merchant_account
		rescue Braintree::NotFoundError => e #this is not technincally an error.  It just means a sub-merchant account has not yet been made for this user
			puts "in braintree not found error"
			nil
		rescue Exception => e
			puts "In the else because of a different error"
			puts "the error is #{e.message}"
			raise "now we are in the else"
		end
	end
end
