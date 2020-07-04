describe 'Book VariantsFunctionality' do
  describe 'Variants Functionality' do
    let(:book) { create(:book) }
    let(:variants) { { Book::VARIANT_TYPES.first => 2, Book::VARIANT_TYPES.second => 2 } }
    let(:reverse_order_variants) { { Book::VARIANT_TYPES.last => 100, Book::VARIANT_TYPES.first => expected_price } }
    let(:form_variants) do
      { Book::VARIANT_TYPES.first => { 'is_available' => 1, 'price' => expected_price },
        Book::VARIANT_TYPES.second => { 'is_available' => 0, 'price' => 2 } }
    end

    let(:form_variants_transformed) { { Book::VARIANT_TYPES.first => expected_price } }
    let(:expected_price) { 2 }

    let(:wrong_key_variants) { { Book::VARIANT_TYPES.first => 2, Faker::Hipster.word => 2 } }
    let(:wrong_price_variants_less) { { Book::VARIANT_TYPES.first => -1 } }
    let(:wrong_price_variants_more) { { Book::VARIANT_TYPES.first => 10_001 } }

    it 'does not save book when variants contain a key that is not present within variant types' do
      book.update(available_variants: wrong_key_variants)
      expect(book.valid?).to eq false
      expect(book).to have_validation_error :base, :variants_invalid
    end

    it 'does not save book when variants contain a price that is lower than 0' do
      book.update(available_variants: wrong_price_variants_less)
      expect(book.valid?).to eq false
      expect(book).to have_validation_error :base, :variants_price_invalid
    end

    it 'does not save book when variants contain a price that is greater than 10000' do
      book.update(available_variants: wrong_price_variants_more)
      expect(book.valid?).to eq false
      expect(book).to have_validation_error :base, :variants_price_invalid
    end

    %w(audio ebook).each do |variant|
      it "does not save book when #{variant} variant is provided without file" do
        book.update(available_variants: variants.merge(variant => 2))
        expect(book.valid?).to eq false
        expect(book).to have_validation_error :base, :variants_files_invalid
      end
    end

    it 'saves book with ok variants' do
      expect(book.update(available_variants: variants)).to eq true
    end

    describe '#update_price_from_variants' do
      it 'infers price from available variant' do
        book.assign_attributes(available_variants: variants)
        book.send(:update_price_from_variants)
        expect(book.main_price).to eq expected_price.to_d
      end

      it 'infers first best price from available variants' do
        book.assign_attributes(available_variants: reverse_order_variants)
        book.send(:update_price_from_variants)
        expect(book.main_price).to eq expected_price.to_d
      end

      it 'calls #update_price_from_variants in callback and saves book' do
        expect(book.main_price).not_to be_present
        book.update(available_variants: variants)
        expect(book.main_price).to eq expected_price.to_d
      end
    end

    describe '#variants=' do
      it 'saves available variants provided from hash variants' do
        book.update(variants: form_variants)
        expect(book.available_variants).to eq form_variants_transformed
      end
    end

    describe '#price_of' do
      it 'returns price of provided variant' do
        book = create(:book, :hardcover, variant_price: 50.0)
        expect(book.price_of(:hardcover)).to eq 50.0
      end

      it 'returns 0 if provided variant is not available' do
        expect(create(:book, :hardcover).price_of(:ebook)).to eq 0.0
      end
    end

    describe '.fetch_if_available' do
      let(:book) { create(:book, :hardcover) }

      it 'returns book if it is available' do
        expect(Book.fetch_if_available(book.id, :hardcover).id).to eq book.id
      end

      it 'returns nil if book cannot be found' do
        expect(Book.fetch_if_available(0, :hardcover)).not_to be_present
      end

      it 'returns nil if variant is unavailable' do
        expect(Book.fetch_if_available(book.id, :ebook)).not_to be_present
      end
    end
  end
end
