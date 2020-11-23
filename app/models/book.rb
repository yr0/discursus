# frozen_string_literal: true

class Book < ApplicationRecord
  WORKBOOKS_UNAVAILABLE_FOR_DOWNLOAD = [129, 126, 127, 128, 130].freeze

  include VariantsFunctionality # before_save, validate

  validates :title, presence: true, length: { minimum: 1, maximum: 250 }
  validates :pages_amount, presence: true, numericality: { greater_than: 0 }
  validates :description, :cover_designer, :translator, :age_recommendations, :authors_within_anthology,
            length: { maximum: 10_000 }
  validates :weight, :dimensions, :isbn, length: { maximum: 1000 }
  validates :published_at, presence: true

  has_many :authors_books, dependent: :destroy
  has_many :authors, through: :authors_books, dependent: :nullify
  has_many :extra_images, class_name: 'BookExtraImage', dependent: :destroy
  has_many :users_favorite_books, dependent: :destroy
  has_many :favorited_by_users, through: :users_favorite_books, source: :user
  has_many :tokens_for_digital_books, dependent: :restrict_with_error
  has_many :line_items, dependent: :restrict_with_error

  has_one :books_series, dependent: :destroy
  has_one :series, through: :books_series

  accepts_nested_attributes_for :extra_images,
                                reject_if: ->(attrs) { attrs['id'].blank? && attrs['image'].blank? },
                                allow_destroy: true

  mount_uploader :image, ImageUploader
  mount_uploader :fragment_file, PublicPdfUploader
  mount_uploader :ebook_file, PdfUploader
  mount_uploader :audio_file, AudioUploader

  scope :top_recent, -> { order(is_top: :desc, published_at: :desc) }
  scope :available, -> { where(is_available: true) }

  acts_as_taggable_on :categories

  extend FriendlyId
  friendly_id :title, use: :slugged
  include Sluggable

  searchable do
    text :title, boost: 5.0
    text(:authors, boost: 3.0) { authors.pluck(:name).join(' ') if authors.present? }
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

  class << self
    def with_authors
      includes(:authors).group(:id)
    end

    def all_categories
      ActsAsTaggableOn::Tag
        .joins(:taggings)
        .where(taggings: { context: 'categories', taggable_type: 'Book' })
        .order('tags.name ASC')
        .distinct
    end
  end

  # Returns names of book authors separated by comma.
  # USE with_authors scope whenever possible!
  def author_names
    # we prefer #map on eager load, because #pluck would use the additional sql query per book
    @author_names ||= authors.loaded? ? authors.map(&:name) : authors.pluck(:name)
  end
end
