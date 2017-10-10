class Author < ApplicationRecord
  acts_as_list
  scope :named_like, ->(q) { where('name ILIKE ?', "%#{q}%") }
  scope :for_index, -> { where.not(image: nil).order("reverse(split_part(reverse(authors.name), ' ', 1)) ASC") }

  validates :name, presence: true, length: { minimum: 3, maximum: 250 }
  after_commit -> { books.all.each(&:index!) }, on: %i(update destroy)

  has_many :authors_books
  has_many :books, through: :authors_books

  extend FriendlyId
  friendly_id :name, use: :slugged
  include Sluggable

  mount_uploader :image, ImageUploader

  def self.with_last_book_titles
    books_subquery = Book.select(:title).top_recent.limit(3)
    select("DISTINCT ON (authors.id) authors.*, array_to_string(array(#{books_subquery.to_sql}), ', ') "\
           'AS last_book_titles').left_joins(:books)
  end

  # A fallback that returns a string containing 3 books of the author
  # USE with_last_book_titles scope whenever possible
  def last_book_titles
    # we prefer #[] and #map on eager load, because #limit and #pluck would use the additional sql query per author
    @last_book_titles ||= if books.loaded?
                            books[0..3].map(&:title).join(', ')
                          else
                            books.limit(3).pluck(:title).join(', ')
                          end
  end
end
