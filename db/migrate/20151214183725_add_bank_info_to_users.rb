class AddBankInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :account_number, :string
    add_column :users, :routing_number, :string
  end
end
