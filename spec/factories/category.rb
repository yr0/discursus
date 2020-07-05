# frozen_string_literal: true

FactoryGirl.define do
  factory :category, class: ActsAsTaggableOn::Tag do
    sequence(:name) { |n| "#{Faker::Hacker.noun}-#{n}" }
  end
end
