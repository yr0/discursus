class Order < ApplicationRecord
  # If user passes password and confirmation, they will be validated and stored as digests
  has_secure_password validations: false

  SHIPPING_METHODS = %w(nova_poshta pickup ukrposhta).freeze
  AVAILABLE_SHIPPING_METHODS = %w(nova_poshta ukrposhta).freeze
  PAYMENT_METHODS = %w(card cash).freeze
  AVAILABLE_PAYMENT_METHODS = %w(card cash).freeze
  FREE_SHIPPING_METHOD = 'ukrposhta'.freeze

  enum shipping_method: SHIPPING_METHODS.map { |sm| [sm, sm] }.to_h
  enum payment_method: PAYMENT_METHODS.map { |pm| [pm, pm] }.to_h

  include OrdersFunctionality # before_create, state machine callbacks, validations
  before_validation :try_to_fetch_promo_code, :set_default_payment_method
  after_save :recalculate_total, if: -> { raw_promo_code.present? && raw_promo_code_changed? && promo_code_id.present? }

  belongs_to :customer, polymorphic: true
  belongs_to :promo_code
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
    if line_items.any?
      line_items_total = line_items.pluck(:price, :quantity).map { |pq| pq.reduce(&:*) }.reduce(&:+)
      update(total_no_promo: line_items_total, total: total_with_promo_discounts(line_items_total), raw_promo_code: nil)
    else
      update(total_no_promo: 0.0, total: 0.0, raw_promo_code: nil)
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

  private

  def total_with_promo_discounts(amount)
    return amount if promo_code.blank?
    promo_code.apply_discount(amount)
  end

  def try_to_fetch_promo_code
    return if raw_promo_code&.strip.blank?
    self.promo_code = PromoCode.find_by_code(raw_promo_code)
  end

  def set_default_payment_method
    self.payment_method ||= AVAILABLE_PAYMENT_METHODS.first
  end
end
