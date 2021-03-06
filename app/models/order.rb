# frozen_string_literal: true

class Order < ApplicationRecord
  # If user passes password and confirmation, they will be validated and stored as digests
  has_secure_password validations: false

  PromoCodeError = Class.new(RuntimeError)
  SHIPPING_METHODS = %w(nova_poshta pickup ukrposhta).freeze
  AVAILABLE_SHIPPING_METHODS = %w(nova_poshta ukrposhta).freeze
  PAYMENT_METHODS = %w(card cash).freeze
  AVAILABLE_PAYMENT_METHODS = %w(card cash).freeze
  FREE_SHIPPING_METHOD = 'ukrposhta'

  enum shipping_method: SHIPPING_METHODS.map { |sm| [sm, sm] }.to_h
  enum payment_method: PAYMENT_METHODS.map { |pm| [pm, pm] }.to_h

  include OrdersFunctionality # before_create, state machine callbacks, validations
  before_validation :set_default_payment_method

  belongs_to :customer, polymorphic: true
  belongs_to :promo_code, optional: true
  has_many :line_items, dependent: :destroy
  has_many :books, through: :line_items
  has_many :tokens_for_digital_books, dependent: :destroy
  has_many :payments, dependent: :restrict_with_error

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

  def recalculate
    with_lock do
      recalculate_total
      recalculate_balance
    end
  end

  def recalculate_balance
    update!(balance: total - payments.succeeded.sum(:amount))
  end

  def recalculate_total
    if line_items.any?
      line_items_total = line_items.pluck(:price, :quantity).map { |pq| pq.reduce(&:*) }.reduce(&:+)

      update!(
        total_no_promo: line_items_total,
        total: total_with_promo_discounts(line_items_total)
      )
    else
      update!(total_no_promo: 0.0, total: 0.0, raw_promo_code: nil)
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

  def apply_promo_code(code)
    self.promo_code = PromoCode.fetch_by_code(code)
    validate_promo_code!

    save! && recalculate
  end

  private

  def total_with_promo_discounts(amount)
    return amount if promo_code.nil?

    promo_code.apply_discount(amount)
  end

  def set_default_payment_method
    self.payment_method ||= AVAILABLE_PAYMENT_METHODS.first
  end

  def validate_promo_code!
    offense = %w(blank expired exhausted).find { |predicate| promo_code.send("#{predicate}?") }

    raise PromoCodeError, I18n.t("errors.messages.promo_code.#{offense}") if offense.present?
  end
end
