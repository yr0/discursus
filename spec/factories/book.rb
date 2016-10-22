FactoryGirl.define do
  factory :book do
    title Faker::Book.title
    pages_amount 200
    description Faker::Lorem.paragraph
  end
end
