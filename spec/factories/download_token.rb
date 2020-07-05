# frozen_string_literal: true

FactoryGirl.define do
  factory :download_token, class: 'TokenForDigitalBook' do
    order { create(:order, :with_line_items, :paid_for, book_variant: :audio) }
    book { order.line_items.first.book }
  end
end
