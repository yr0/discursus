# frozen_string_literal: true

describe LineItem do
  describe 'callbacks' do
    let(:book) { create(:book, :hardcover, main_price: 50) }
    let(:order) { create(:order) }
    let(:line_item) { create(:line_item, order: order, book: book) }

    it 'stores book price before validation' do
      expect(line_item.price).to be_present
      expect(line_item.price).to eq line_item.book.main_price
    end

    it 'recalculates order total after create' do
      order
      expect { line_item }.to change { order.total.to_f }.by book.main_price
    end

    it 'recalculates order total after update' do
      line_item
      expect { line_item.update(quantity: 2) }.to change { order.total.to_f }.by book.main_price
    end

    it 'recalculates order total after destroy' do
      line_item
      expect { line_item.destroy }.to change { order.total.to_f }.by(-book.main_price)
    end
  end

  describe 'scopes' do
    let!(:order) { create(:order) }
    let!(:digital) { [create(:line_item, :ebook, order: order), create(:line_item, :audio, order: order)] }
    let!(:physical) { [create(:line_item, :hardcover, order: order), create(:line_item, :paperback, order: order)] }

    it 'returns only line items with digital books' do
      expect(order.line_items.digital.pluck(:id)).to match_array(digital.map(&:id))
    end

    it 'returns only line items with physical books' do
      expect(order.line_items.physical.pluck(:id)).to match_array(physical.map(&:id))
    end
  end

  describe 'public instance methods' do
    it 'returns true if line item has digital book' do
      expect(create(:line_item, :ebook).digital?).to be_present
      expect(create(:line_item, :audio).digital?).to be_present
    end

    it 'returns total price of line item' do
      book = create(:book, :hardcover, variant_price: 50.0)
      item = create(:line_item, book: book, variant: :hardcover, quantity: 3)
      expect(item.total).to eq 50.0 * 3
    end
  end

  describe 'Populating' do
    describe '.find_and_populate' do
      let(:book) { create(:book, :hardcover) }
      let(:order) { create(:order) }

      it 'creates line item and sets it\'s quantity to 1 for new record' do
        order
        expect do
          order.line_items.find_and_populate(book.id, :hardcover)
        end.to change { order.line_items.size }.by 1
      end

      it 'raises error if book cannot be found by provided id' do
        expect { order.line_items.find_and_populate(0, :hardcover) }
          .to raise_error(Populating::OrderPopulatingError, I18n.t('orders.errors.variant_unavailable'))
      end

      it 'raises error if book variant is unavailable' do
        expect { order.line_items.find_and_populate(book.id, :audio) }
          .to raise_error(Populating::OrderPopulatingError, I18n.t('orders.errors.variant_unavailable'))
      end
    end

    describe '#change_quantity_by' do
      let(:order) { create(:order) }
      let(:item) { create(:line_item, :hardcover, quantity: 3, order: order) }

      it 'increases line item quantity if amount is positive' do
        expect { item.change_quantity_by(1) }.to change { item.quantity.to_i }.by 1
      end

      it 'decreases line item quantity if amount is negative' do
        expect { item.change_quantity_by(-1) }.to change { item.quantity.to_i }.by(-1)
      end

      it 'destroys line item if amount is negative and equal to previous quantity' do
        item
        expect do
          item.change_quantity_by(-3)
          expect { item.reload }.to raise_error(ActiveRecord::RecordNotFound)
        end.to change { order.line_items.size }.by(-1)
      end

      VariantsFunctionality::VARIANTS_BOUGHT_ONCE.each do |variant|
        it "raises error if #{variant} book variant is attempted to be bought twice" do
          line_item = create(:line_item, variant.to_sym)
          expect { line_item.change_quantity_by(1) }
            .to raise_error(Populating::OrderPopulatingError, I18n.t('orders.errors.variant_is_bought_once'))
        end

        it "does not raise error if #{variant} book variant quantity is being decreased" do
          line_item = create(:line_item, variant.to_sym)
          expect { line_item.change_quantity_by(-1) }.not_to raise_error
        end
      end
    end
  end
end
