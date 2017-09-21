FactoryGirl.define do
  factory :book do
    transient do
      variant_price 20.0
    end

    sequence(:title) { |n| "#{Faker::Book.title}-#{n}" }
    pages_amount 200
    year 1984
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
          { variant_kind => { 'is_available' => 1, 'price' => variant_price } }
        end

        if variant_kind == 'ebook'
          ebook_file { Rack::Test::UploadedFile.new(Rails.root.join(*%w(spec fixtures files book.pdf))) }
        elsif variant_kind == 'audio'
          audio_file { Rack::Test::UploadedFile.new(Rails.root.join(*%w(spec fixtures files book.mp3))) }
        end
      end
    end

    trait :digital do
      variant_kind = %w(ebook audio).sample
      variants do
        { variant_kind => { 'is_available' => 1, 'price' => variant_price } }
      end

      if variant_kind == 'ebook'
        ebook_file { Rack::Test::UploadedFile.new(Rails.root.join(*%w(spec fixtures files book.pdf))) }
      else
        audio_file { Rack::Test::UploadedFile.new(Rails.root.join(*%w(spec fixtures files book.mp3))) }
      end
    end

    trait :physical do
      variants do
        { %w(paperback hardcover).sample => { 'is_available' => 1, 'price' => variant_price } }
      end
    end
  end
end
