class Transaction < ActiveRecord::Base
  belongs_to :document
  belongs_to :buyer, class_name: 'User', foreign_key: 'buyer_id'
  belongs_to :author
end
