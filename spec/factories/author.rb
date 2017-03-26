FactoryGirl.define do
  factory :author do
    sequence(:name) { Faker::GameOfThrones.character }

    trait :with_books do
      books { [create(:book)] }
    end
  end
end
