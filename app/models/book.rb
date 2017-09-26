class Book < ApplicationRecord
  include VariantsFunctionality # before_save, validate

  validates :title, presence: true, length: { minimum: 1, maximum: 250 }
  validates :pages_amount, presence: true, numericality: { greater_than: 0 }
  validates :description, :cover_designer, :translator, :age_recommendations, :authors_within_anthology,
            length: { maximum: 10_000 }
  validates :weight, :dimensions, :isbn, length: { maximum: 1000 }
  validates :published_at, presence: true

  has_many :authors_books
  has_many :authors, through: :authors_books
  has_many :extra_images, class_name: 'BookExtraImage'
  has_many :tokens_for_digital_books
  has_many :users_favorite_books
  has_many :favorited_by_users, through: :users_favorite_books, source: :user

  accepts_nested_attributes_for :extra_images,
                                reject_if: ->(attrs) { attrs['id'].blank? && attrs['image'].blank? },
                                allow_destroy: true

  mount_uploader :image, ImageUploader
  mount_uploader :fragment_file, PublicPdfUploader
  mount_uploader :ebook_file, PdfUploader
  mount_uploader :audio_file, AudioUploader

  default_scope { order(is_available: :desc, created_at: :desc) }
  scope :available, -> { where(is_available: true) }

  acts_as_taggable_on :categories

  extend FriendlyId
  friendly_id :title, use: :slugged
  include Sluggable

  searchable do
    text :title, boost: 5.0
    text :description
    string(:title_for_sorting) { title.downcase }
    time :created_at
    boolean :is_available
    boolean :is_top
    date :published_at
    double :main_price
    integer :category_ids, multiple: true
    integer :author_ids, multiple: true
  end

  def self.all_categories
    ActsAsTaggableOn::Tag.joins(:taggings).where(taggings: { context: 'categories', taggable_type: 'Book' }).distinct
  end

  # Returns names of book authors separated by comma
  def author_names
    # we prefer #map on eager load, because #pluck would use the additional sql query per book
    @author_names ||= if authors.loaded?
                        authors.map(&:name).join(', ')
                      else
                        authors.pluck(:name).join(', ')
                      end
  end
end
