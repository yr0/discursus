# frozen_string_literal: true

FactoryGirl.define do
  factory :author do
    transient do
      books_amount 1
    end

    sequence(:name) { |n| "#{Faker::GameOfThrones.character}-#{n}" }

    trait :with_books do
      books { create_list(:book, books_amount) }
    end
  end
end
