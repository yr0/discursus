FactoryGirl.define do
  factory :order do
    transient do
      book_variant :hardcover
    end

    sequence(:email) { Faker::Internet.email }
    customer { create(:user) }

    trait :with_line_items do
      after(:build) do |order, evaluator|
        order.line_items = [create(:line_item, evaluator.book_variant.to_sym, order: order)]
      end
    end

    trait :digital_and_physical do
      after(:build) do |order|
        order.line_items = [create(:line_item, :hardcover, order: order), create(:line_item, :ebook, order: order)]
      end
    end

    trait :with_temporary_user do
      customer { create(:temporary_user) }
    end
  end
end
