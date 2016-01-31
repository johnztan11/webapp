class Transaction < ActiveRecord::Base
  belongs_to :document
  belongs_to :buyer, class_name: 'User', foreign_key: 'buyer_id'
  belongs_to :author
<<<<<<< HEAD

  after_create :send_to_user

  def send_to_user
  	puts "in send_to_user method".green
  	puts "self before if is #{self.inspect}".green
  	if self.non_user_email
  		puts "self is #{self.inspect}".blue
      puts "document is #{self.document}".green
  		@document = Document.find(self.document_id)
  		@email = self.non_user_email
  		TransactionsMailer.send_to_unsigned_in_user(@email, @document)
  	end
  end
=======
>>>>>>> d09c65119222ff934cab626b7424472ced92d7f9
end
