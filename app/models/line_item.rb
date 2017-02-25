class LineItem < ApplicationRecord
  include Populating

  # store variant as string in database
  enum variant: VariantsFunctionality::VARIANT_TYPES.map { |v| [v, v] }.to_h

  scope :digital, -> { where(variant: %w(ebook audio)) }
  scope :physical, -> { where.not(variant: %w(ebook audio)) }

  belongs_to :book
  belongs_to :order

  # recalculate total order sum after creation, updating, or deletion
  after_commit -> { order.recalculate_total }

  def digital?
    ebook? || audio?
  end

  def total
    price * quantity
  end
end
