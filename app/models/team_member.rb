# frozen_string_literal: true

class TeamMember < ApplicationRecord
  acts_as_list

  default_scope { order(position: :asc) }

  with_options presence: true do
    validates :name, length: { minimum: 3, maximum: 250 }
    validates :role, length: { minimum: 3, maximum: 150 }
    validates :image
  end

  validates :motto, allow_blank: true, length: { minimum: 2, maximum: 250 }
  mount_uploader :image, ImageUploader
end
