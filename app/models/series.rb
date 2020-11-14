# frozen_string_literal: true

class Series < ApplicationRecord
  validates :title, :slug, presence: true
  validates :description, length: { maximum: 10_000 }

  has_many :books_series, dependent: :destroy
  has_many :books, through: :books_series
end
