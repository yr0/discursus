class Order < ApplicationRecord
  # If user passes password and confirmation, they will be validated and stored as digests
  has_secure_password validations: false

  SHIPPING_METHODS = %w(nova_poshta ukrposhta pickup).freeze
  PAYMENT_METHODS = %w(card cash).freeze

  enum shipping_method: SHIPPING_METHODS.map { |sm| [sm, sm] }.to_h
  enum payment_method: PAYMENT_METHODS.map { |pm| [pm, pm] }.to_h

  include OrdersFunctionality # before_create, state machine callbacks, validations

  belongs_to :customer, polymorphic: true
  has_many :line_items
  has_many :books, through: :line_items
  has_many :tokens_for_digital_books

  def requires_shipping?
    physical?
  end

  def physical?
    line_items.physical.any?
  end

  def digital?
    line_items.digital.any?
  end

  def address
    [city, street].reject(&:blank?).join('. ')
  end

  def recalculate_total
    # we might add cost of shipping here
    if line_items.any?
      update(total: line_items.pluck(:price, :quantity).map { |e| e.reduce(&:*) }.reduce(&:+))
    else
      update(total: 0.0)
    end
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

  def payment_url
    'https://google.com'
  end
end
