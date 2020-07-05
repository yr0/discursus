class Setting < ApplicationRecord
  validates :email, :phone, :facebook, :instagram, :twitter, :home_hero_title, length: { maximum: 255 }
  validates :email, :phone, :home_hero_title, presence: true
  validates :home_hero_details, length: { maximum: 500 }

  mount_uploader :home_hero_image, ImageUploader

  class << self
    def retrieve
      first
    end

    def store!(data)
      retrieve.tap { |s| s.update(data) }
    end
  end
end
