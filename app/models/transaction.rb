class Transaction < ActiveRecord::Base
  belongs_to :document
  belongs_to :buyer, class_name: 'User', foreign_key: 'buyer_id'
  belongs_to :author

  after_create :send_to_user

  def send_to_user
  	puts "in send_to_user method".green
  	if self.non_user_email
  		puts "self is #{@self.inspect}".blue
  		@document = self.document
  		@email = self.non_user_email
  		TransactionsMailer.send_to_unsigned_in_user(@email, @document)
  	end
  end
end
