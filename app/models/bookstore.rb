class Bookstore < ApplicationRecord
  with_options presence: true do
    validates :title, length: { minimum: 1, maximum: 250 }
    validates :location_name, length: { minimum: 5, maximum: 1000 }
    validates :location_lat, numericality: true
    validates :location_lng, numericality: true
  end

  validates :description, allow_blank: true, length: { minimum: 5, maximum: 10_000 }

  mount_uploader :image, MainImageUploader
end
