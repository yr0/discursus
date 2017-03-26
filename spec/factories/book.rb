FactoryGirl.define do
  factory :book do
    sequence(:title) { |n| "#{Faker::Book.title}-#{n}" }
    pages_amount 200
    description Faker::Lorem.paragraph

    trait :with_authors do
      authors { [create(:author)] }
    end

    trait :with_categories do
      categories { [create(:category)] }
    end

    VariantsFunctionality::VARIANT_TYPES.each do |variant_kind|
      trait variant_kind.to_sym do
        variants do
          { variant_kind => { 'is_available' => 1, 'price' => 20.0 } }
        end
      end
    end

    trait :digital do
      variants do
        { %w(ebook audio).sample => { 'is_available' => 1, 'price' => 20.0 } }
      end
    end

    trait :physical do
      variants do
        { %w(paperback hardcover).sample => { 'is_available' => 1, 'price' => 20.0 } }
      end
    end
  end
end
