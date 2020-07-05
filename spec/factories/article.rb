# frozen_string_literal: true

FactoryGirl.define do
  factory :article do
    sequence(:title) { Faker::Book.title }
    body Faker::Lorem.paragraph
  end
end
