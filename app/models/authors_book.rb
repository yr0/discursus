# frozen_string_literal: true

class AuthorsBook < ApplicationRecord
  acts_as_list scope: :book
  default_scope { order('authors_books.position ASC') }

  belongs_to :book, touch: true
  belongs_to :author, touch: true, optional: true # TODO: fix the occurrence of such records
end
