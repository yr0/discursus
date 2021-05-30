# frozen_string_literal: true

FactoryGirl.define do
  factory :payment do
    order

    amount { 50.0 }
    payment_type { 'card' }
  end
end
