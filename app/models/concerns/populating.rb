# frozen_string_literal: true

module Populating
  extend ActiveSupport::Concern

  class OrderPopulatingError < StandardError; end

  module ClassMethods
    # fetches book and variant from provided data and then modifies line item's quantity
    def find_and_populate(book_id, variant)
      book = get_book_if_available(book_id, variant)
      line_item = find_or_initialize_by(book: book, variant: variant)
      line_item.change_quantity_by(1)
    end

    private

    def get_book_if_available(book_id, variant)
      Book.fetch_if_available(book_id, variant) ||
        raise(OrderPopulatingError, I18n.t('orders.errors.variant_unavailable'))
    end
  end

  # Either increases the line item's quantity or decreases it. Will destroy item if quantity turns out less than 1
  def change_quantity_by(amount)
    check_purchasing_multiple! if amount.positive?
    desired_quantity = quantity.to_i + amount
    if desired_quantity < 1
      destroy! if persisted?
    else
      self.quantity = desired_quantity
      save!
    end
  end

  private

  def check_purchasing_multiple!
    raise OrderPopulatingError, I18n.t('orders.errors.variant_is_bought_once') if
        VariantsFunctionality::VARIANTS_BOUGHT_ONCE.include?(variant) && quantity.to_i.positive?
  end
end
