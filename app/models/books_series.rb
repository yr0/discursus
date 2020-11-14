# frozen_string_literal: true

class BooksSeries < ApplicationRecord
  belongs_to :book
  belongs_to :series
end
