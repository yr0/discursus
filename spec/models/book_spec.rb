describe Book, type: :model do
  context 'available_variants' do
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
      expect(book._has_base_error?(:variants_invalid)).to be
    end

    it 'does not save book when variants contain a price that is lower than 0' do
      book.update(available_variants: wrong_price_variants_less)
      expect(book.valid?).to eq false
      expect(book._has_base_error?(:variants_price_invalid)).to be
    end

    it 'does not save book when variants contain a price that is greater than 10000' do
      book.update(available_variants: wrong_price_variants_more)
      expect(book.valid?).to eq false
      expect(book._has_base_error?(:variants_price_invalid)).to be
    end

    %w(audio ebook).each do |variant|
      it "does not save book when #{variant} variant is provided without file" do
        book.update(available_variants: variants.merge(variant => 2))
        expect(book.valid?).to eq false
        expect(book._has_base_error?(:variants_files_invalid)).to be
      end
    end

    it 'saves book with ok variants' do
      expect(book.update(available_variants: variants)).to eq true
    end

    context '#update_price_from_variants' do
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
        expect(book.main_price).not_to be
        book.update(available_variants: variants)
        expect(book.main_price).to eq expected_price.to_d
      end
    end

    context '#variants=' do
      it 'saves available variants provided from hash variants' do
        book.update(variants: form_variants)
        expect(book.available_variants).to eq form_variants_transformed
      end
    end
  end
end
