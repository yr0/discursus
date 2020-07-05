# frozen_string_literal: true

FactoryGirl.define do
  factory :promo_code do
    sequence(:code) { |n| "#{SecureRandom.hex(4)}#{n}" }

    discount_percent 20
    expires_at 1.day.since
    limit 10
  end
end
