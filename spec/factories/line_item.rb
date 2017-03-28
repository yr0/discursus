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

    VariantsFunctionality::VARIANT_TYPES.each do |variant_kind|
      trait variant_kind.to_sym do
        book { create(:book, variant_kind.to_sym) }
        variant { variant_kind }
      end
    end
  end
end
