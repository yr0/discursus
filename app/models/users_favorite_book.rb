# frozen_string_literal: true

class UsersFavoriteBook < ApplicationRecord
  belongs_to :user
  belongs_to :book
end
