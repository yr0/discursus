class Book < ApplicationRecord
  default_scope { order(created_at: :desc) }

  validates :title, presence: true, length: { minimum: 1, maximum: 250 }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :pages_amount, presence: true, numericality: { greater_than: 0 }
  validates :description, length: { maximum: 10_000 }

  has_many :authors_books
  has_many :authors, through: :authors_books

  def author_names
    authors.pluck(:name).join(', ')
  end
end
