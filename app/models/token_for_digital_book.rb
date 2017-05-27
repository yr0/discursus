class TokenForDigitalBook < ApplicationRecord
  belongs_to :order
  belongs_to :book

  enum variant: %w(ebook audio).map { |v| [v, v] }.to_h
  scope :unused, -> { where(is_used: false) }

  before_create :generate_code

  def schedule_used_flag
    UsedTokenJob.set(wait: 5.minutes).perform_later(id)
  end

  private

  def generate_code
    self.code = "#{SecureRandom.hex(10)}#{book_id}#{order_id}"
  end
end
