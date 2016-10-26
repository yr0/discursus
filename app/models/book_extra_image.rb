class BookExtraImage < ApplicationRecord
  acts_as_list scope: :book
  default_scope { order(position: :asc) }

  validates :image, presence: true

  mount_uploader :image, ImageUploader
  belongs_to :book
end
