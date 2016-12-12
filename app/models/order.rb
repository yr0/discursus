class Order < ApplicationRecord
  include OrdersFunctionality::Populating
  include OrdersFunctionality::StateMachine

  belongs_to :customer, polymorphic: true
  has_many :line_items
  has_many :books, through: :line_items

  def requires_shipping?
    line_items.physical.any?
  end

  def recalculate_total
    # we might add cost of shipping here
    update(total: 0.0) unless line_items.any?
    update(total: line_items.pluck(:price, :quantity).map { |e| e.reduce(&:*) }.reduce(&:+))
  end
end
