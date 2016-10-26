class Author < ApplicationRecord
  acts_as_list
  default_scope { order(position: :asc) }
  scope :named_like, ->(q) { where('name ILIKE ?', "%#{q}%") }

  validates :name, presence: true, length: { minimum: 3, maximum: 250 }

  has_many :authors_books
  has_many :books, through: :authors_books

  extend FriendlyId
  friendly_id :name, use: :slugged
  include Sluggable

  mount_uploader :image, ImageUploader
end
