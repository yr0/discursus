FactoryGirl.define do
  factory :order do
    transient do
      book_variant :hardcover
      order_password '123456789'
      order_phone '123123123'
    end

    sequence(:email) { |n| "#{n}_#{Faker::Internet.email}" }
    customer { create(:user) }

    trait :cash do
      payment_method :cash
    end

    trait :card do
      payment_method :card
    end

    trait :with_line_items do
      after(:build) do |order, evaluator|
        order.line_items = [create(:line_item, evaluator.book_variant.to_sym)]
      end
    end

    trait :digital_and_physical do
      after(:build) do |order|
        order.line_items = [create(:line_item, :hardcover), create(:line_item, :ebook)]
      end
    end

    trait :with_temporary_user do
      customer { create(:temporary_user) }
    end

    # order that, after being submitted, swaps temporary user with actual user
    trait :valid_for_user_swap do
      before(:create) do |order, evaluator|
        order.assign_attributes(customer: create(:temporary_user), password: evaluator.order_password,
                                phone: evaluator.order_phone, full_name: Faker::GameOfThrones.character)
      end
    end

    trait :submitted do
      with_line_items
      valid_for_user_swap
      after(:create, &:submit!)
    end

    trait :paid_for do
      submitted
      after(:create, &:pay!)
    end
  end
end
