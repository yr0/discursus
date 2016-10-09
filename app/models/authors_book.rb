class AuthorsBook < ApplicationRecord
  acts_as_list scope: :book
  default_scope { order('authors_books.position ASC') }

  belongs_to :book
  belongs_to :author
end
