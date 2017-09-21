class PromoCode < ApplicationRecord
  has_many :orders, dependent: :nullify

  before_validation -> { self.code = self.class.normalize(code) }
  validates :code, presence: true, uniqueness: true, length: { minimum: 5, maximum: 50 }
  validates :limit, numericality: true, allow_nil: true
  validates :discount_percent, numericality: { minimum: 1, maximum: 99 }, presence: true

  class << self
    def find_by_code(code)
      return if code.blank?
      find_by(code: normalize(code))
    end

    def normalize(string)
      return string if string.blank?
      string.downcase.strip
    end
  end

  def expired?
    expires_at.past?
  end

  def exhausted?
    return false if limit.to_i.zero?
    limit.to_i <= orders_count.to_i
  end

  def used_by?(email)
    Order.completed.where(email: email).any?
  end

  def apply_discount(amount)
    amount - (amount * (discount_percent.to_i / 100))
  end
end
