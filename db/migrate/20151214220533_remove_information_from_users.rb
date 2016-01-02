class RemoveInformationFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :account_number, :string
    remove_column :users, :routing_number, :string
    remove_column :users, :date_of_birth, :string
  end
end
