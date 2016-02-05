class Author < User

	has_many :documents
	has_many :seller_transactions, class_name: 'Transaction', source: :author

	def full_name
  		"#{first_name} #{last_name}"
  	end
end