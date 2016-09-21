class Article < ApplicationRecord
  validates :title, presence: true, length: { minimum: 1, maximum: 50 }
  validates :body, presence: true, length: { minumum: 10, maximum: 30_000 }
end
