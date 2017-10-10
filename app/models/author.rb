class Author < ApplicationRecord
  acts_as_list
  scope :named_like, ->(q) { where('name ILIKE ?', "%#{q}%") }
  scope :with_image, -> { where.not(image: nil) }

  validates :name, presence: true, length: { minimum: 3, maximum: 250 }
  after_commit -> { books.all.each(&:index!) }, on: %i(update destroy)

  has_many :authors_books
  has_many :books, through: :authors_books

  extend FriendlyId
  friendly_id :name, use: :slugged
  include Sluggable

  mount_uploader :image, ImageUploader

  class << self
    def with_last_book_titles
      books_subquery = Book.select(:title).top_recent.limit(3)
      select("DISTINCT ON (authors.id) authors.*, array_to_string(array(#{books_subquery.to_sql}), ', ') "\
           'AS last_book_titles').left_joins(:books)
    end

    def for_index
      books_subquery = Book.select(:title).top_recent.limit(3)
      select('DISTINCT ON (author_surname, authors.id) authors.*, '\
           "reverse(split_part(reverse(authors.name), ' ', 1)) AS author_surname, "\
           "array_to_string(array(#{books_subquery.to_sql}), ', ') "\
           'AS last_book_titles').left_joins(:books)
      .order('author_surname ASC, id ASC')
    end
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
