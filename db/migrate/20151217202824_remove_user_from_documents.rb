class RemoveUserFromDocuments < ActiveRecord::Migration
  def change
    remove_reference :documents, :user, index: true
  end
end
