module OrdersFunctionality
  module Populating
    def populate!(book_id, variant, quantity = 1)
      book = get_book_if_available(book_id, variant)
      line_item = line_items.find_or_initialize_by(book: book, variant: variant)
      raise ActiveRecord::RecordNotSaved, I18n.t('orders.errors.variant_is_bought_once') if
          quantity > 0 && cannot_buy_twice?(line_item)
      line_item.assign_attributes(quantity: line_item.quantity.to_i + quantity, price: book.price_of(variant))
      line_item.save!
    end

    def items?
      line_items.present?
    end

    private

    def get_book_if_available(book_id, variant)
      book = Book.find_by(id: book_id)
      raise ActiveRecord::RecordNotSaved, t('orders.errors.variant_unavailable') unless
          book && book.variant_available?(variant)
      book
    end

    def cannot_buy_twice?(line_item)
      VariantsFunctionality::VARIANTS_BOUGHT_ONCE.include?(line_item.variant) && line_item.quantity.positive?
    end
  end
end
