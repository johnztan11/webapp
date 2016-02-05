class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  attr_accessor :account_number
  attr_accessor :routing_number

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :type, inclusion: {in: %W(Author)}, :allow_nil => true

  has_many :buyer_transactions, class_name: 'Transaction', foreign_key: 'buyer_id'

  def author?
  	self.type == "Author"
  end

  def owned_documents
    @buyer_transactions = self.buyer_transactions
    @documents = @buyer_transactions.collect{|t| t.document}
    @documents
  end

  def has_owned_document?(document)
    owned_documents.include?(document)
  end
  
end
