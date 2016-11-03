class Article < ApplicationRecord
  default_scope { order(created_at: :desc) }

  validates :title, presence: true, length: { minimum: 1, maximum: 100 }
  validates :body, presence: true, length: { minumum: 10, maximum: 30_000 }

  extend FriendlyId
  friendly_id :title, use: :slugged
  include Sluggable

  mount_uploader :image, ImageUploader
end
