# frozen_string_literal: true

class PromoCode < ApplicationRecord
  has_many :orders, dependent: :nullify

  before_validation -> { self.code = self.class.normalize(code) }
  validates :code, presence: true, uniqueness: true, length: { minimum: 5, maximum: 50 }
  validates :limit, numericality: true, allow_nil: true
  validates :discount_percent, numericality: { minimum: 1, maximum: 99 }, presence: true

  class << self
    def fetch_by_code(code)
      return if code.blank?

      find_by(code: normalize(code))
    end

    def normalize(string)
      return string if string.blank?

      string.mb_chars.downcase.strip.to_s
    end
  end

  def expired?
    expires_at.past?
  end

  def exhausted?
    return false if limit.to_i.zero?

    limit.to_i <= orders_count.to_i
  end

  def used_by?(_email)
    false
    # Wrong implementation - disables promo-code for users who made purchase with other PC
    # Order.completed.where(email: email).any?
  end

  def apply_discount(amount)
    amount - (amount * (discount_percent.to_f / 100))
  end
end
