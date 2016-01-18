class AddAuthorToDocuments < ActiveRecord::Migration
  def change
    add_reference :documents, :author, index: true
  end
end
