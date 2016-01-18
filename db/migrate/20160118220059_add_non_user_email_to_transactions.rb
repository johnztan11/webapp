class AddNonUserEmailToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :non_user_email, :string
  end
end
