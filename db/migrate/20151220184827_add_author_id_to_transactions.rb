class AddAuthorIdToTransactions < ActiveRecord::Migration
  def change
    add_reference :transactions, :author, index: true
  end
end
