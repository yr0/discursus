class Order < ApplicationRecord
  SHIPPING_METHODS = %w(nova_poshta ukrposhta pickup)
  PAYMENT_METHODS = %w(card upon_receipt)

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

  def items?
    line_items.present?
  end

  def populate(book_id, variant)
    line_items.find_and_populate(book_id, variant)
  end

  def modify_line_item_quantity(line_item_id, increase, destroy_item = false)
    item = line_items.find(line_item_id)
    if destroy_item
      item.destroy!
    else
      item.change_quantity_by(increase ? 1 : -1)
    end
    item
  end
end
