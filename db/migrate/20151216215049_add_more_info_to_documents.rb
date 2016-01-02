class AddMoreInfoToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :cover, :string
    add_column :documents, :description, :text
    add_column :documents, :price, :integer
  end
end
