FactoryGirl.define do
  factory :line_item do
    book { create(:book, :hardcover) }
    variant { 'hardcover' }
    order
    quantity 1

    trait :digital do
      book { create(:book, :digital) }
    end

    trait :physical do
      book { create(:book, :physical) }
    end
  end
end
