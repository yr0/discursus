class LineItem < ApplicationRecord
  include Populating

  # store variant as string in database
  enum variant: VariantsFunctionality::VARIANT_TYPES.map { |v| [v, v] }.to_h

  before_validation -> { self.price = book.price_of(variant) }
  validates :book_id, presence: true
  validates :order_id, presence: true
  validates :price, :quantity, numericality: true, presence: true
  validates :variant, presence: true

  # recalculate total order sum after creation, updating, or deletion
  after_commit -> { order.recalculate_total }

  scope :digital, -> { where(variant: %w(ebook audio)) }
  scope :physical, -> { where.not(variant: %w(ebook audio)) }

  belongs_to :book
  belongs_to :order

  def digital?
    ebook? || audio?
  end

  def total
    price * quantity
  end
end
