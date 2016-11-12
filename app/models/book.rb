class Book < ApplicationRecord
  include VariantsFunctionality

  before_save :update_price_from_variants, if: :available_variants_changed?

  validates :title, presence: true, length: { minimum: 1, maximum: 250 }
  validates :pages_amount, presence: true, numericality: { greater_than: 0 }
  validates :description, length: { maximum: 10_000 }
  # validate :variants_must_contain_valid_data

  has_many :authors_books
  has_many :authors, through: :authors_books
  has_many :extra_images, class_name: 'BookExtraImage'
  accepts_nested_attributes_for :extra_images, reject_if: ->(attrs) { attrs['id'].blank? && attrs['image'].blank? },
                                allow_destroy: true

  mount_uploader :image, ImageUploader
  mount_uploader :ebook_file, PdfUploader
  mount_uploader :audio_file, AudioUploader

  default_scope { order(created_at: :desc) }

  acts_as_taggable_on :categories

  extend FriendlyId
  friendly_id :title, use: :slugged
  include Sluggable

  def self.all_categories
    ActsAsTaggableOn::Tag.joins(:taggings).where(taggings: { context: 'categories', taggable_type: 'Book' })
  end

  def author_names
    # we use #map, because #pluck would use the additional sql query per book,
    # which we avoid using Book.includes(:authors)
    authors.map(&:name).join(', ')
  end
end
