# frozen_string_literal: true

FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "#{n}_#{Faker::Internet.email}" }
    password '123456789'
  end
end
