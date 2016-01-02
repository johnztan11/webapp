class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.belongs_to :document, index: true
      t.belongs_to :buyer, index: true
      t.integer :amount

      t.timestamps
    end
  end
end
