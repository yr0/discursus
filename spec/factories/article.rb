FactoryGirl.define do
  factory :article do
    sequence(:title) { Faker::Book.title }
    body Faker::Lorem.paragraph
  end
end
