FactoryGirl.define do
  factory :order do
    sequence(:email) { Faker::Internet.email }
    customer { create(:user) }

    after(:build) do |order|
      order.line_items = [create(:line_item, order: order)]
    end

    trait :with_temporary_user do
      customer { create(:temporary_user) }
    end
  end
end
