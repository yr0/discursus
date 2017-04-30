class TokenForDigitalBook < ApplicationRecord
  belongs_to :order
  belongs_to :book

  enum variant: %w(ebook audio).map { |v| [v, v] }.to_h

  before_create :generate_code

  private

  def generate_code
    self.code = "#{SecureRandom.hex(10)}#{book_id}#{order_id}"
  end
end
