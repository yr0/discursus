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

  # returns a string containing last 3 books of the author
  def last_book_titles
    # we prefer #[] and #map on eager load, because #limit and #pluck would use the additional sql query per author
    @last_book_titles ||= if books.loaded?
                            books[0..3].map(&:title).join(', ')
                          else
                            books.limit(3).pluck(:title).join(', ')
                          end
  end
end
