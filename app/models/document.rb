class Document < ActiveRecord::Base
  belongs_to :author
  has_many :transactions
  mount_uploader :doc, DocUploader
  mount_uploader :cover, CoverUploader

  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :cover, presence: true
  validates :doc, presence: true
  validates :author, presence: true

<<<<<<< HEAD
  def created_by?(user)
    self.author == user
  end

=======
>>>>>>> d09c65119222ff934cab626b7424472ced92d7f9
end
