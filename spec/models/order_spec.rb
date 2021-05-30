# frozen_string_literal: true

describe Order do
  describe '#physical?' do
    subject { order.physical? }

    let(:order) { create(:order, :with_line_items) }

    it { is_expected.to eq true }

    context 'when the order includes both physical and digital line items' do
      let(:order) { create(:order, :digital_and_physical) }

      it { is_expected.to eq true }
    end

    context 'when the order does not contain physical line items' do
      let(:order) { create(:order, :with_line_items, book_variant: :ebook) }

      it { is_expected.to eq false }
    end
  end

  describe '#digital?' do
    subject { order.digital? }

    let(:order) { create(:order, :with_line_items, book_variant: :ebook) }

    it { is_expected.to eq true }

    context 'when the order includes both physical and digital line items' do
      let(:order) { create(:order, :digital_and_physical) }

      it { is_expected.to eq true }
    end

    context 'when the order does not contain digital line items' do
      let(:order) { create(:order, :with_line_items) }

      it { is_expected.to eq false }
    end
  end

  describe '#address' do
    subject { order.address }

    let(:order) { create(:order, city: city, street: street) }
    let(:city) { Faker::Pokemon.location }
    let(:street) { Faker::TwinPeaks.location }

    it { is_expected.to eq "#{city}. #{street}" }

    context 'when city is not provided' do
      let(:city) { nil }

      it { is_expected.to eq(street) }
    end

    context 'when street is not provided' do
      let(:street) { nil }

      it { is_expected.to eq(city) }
    end
  end

  describe '#recalculate_total' do
    subject { order.recalculate_total; order.reload.total }

    let(:order) { create(:order) }

    it { is_expected.to eq 0.0 }

    context 'when order contains line items' do
      let!(:line_item) { create(:line_item, order: order) }

      it { is_expected.to eq line_item.price * line_item.quantity }
    end

    context 'when a promo code is attached to the order' do
      let(:promo_code) { create(:promo_code, discount_percent: 20) }
      let!(:line_item) { create(:line_item, order: order) }

      before do
        order.update!(promo_code: promo_code)
      end

      it { is_expected.to eq(line_item.price * line_item.quantity * 0.8) }

      context 'with multiple recalculations' do
        before do
          order.recalculate_total
        end

        it { is_expected.to eq(line_item.price * line_item.quantity * 0.8) }
      end
    end
  end

  describe '#items?' do
    subject { order.items? }

    let(:order) { create(:order, :with_line_items) }

    it { is_expected.to eq true }

    context 'when order includes no line items' do
      let(:order) { create(:order) }

      it { is_expected.to eq false }
    end
  end

  describe '#populate' do
    subject { order.populate(book.id, :hardcover) }

    let(:order) { create(:order) }
    let(:book) { create(:book, :hardcover) }

    it 'updates the line items of the order' do
      expect { subject }.to change { order.line_items.count }.by(1)
    end
  end

  describe '#modify_line_item_quantity' do
    subject { order.modify_line_item_quantity(line_item.id, increase, destroy_item) }

    let(:order) { create(:order) }
    let(:line_item) { create(:line_item, order: order, quantity: 2) }
    let(:increase) { true }
    let(:destroy_item) { false }

    it 'increases amount of line item by 1' do
      expect { subject }.to change { line_item.reload.quantity }.by 1
    end

    context 'when increase is false' do
      let(:increase) { false }

      it 'decreases amount of line item by 1' do
        expect { subject }.to change { line_item.reload.quantity }.by(-1)
      end
    end

    context 'when destroy_item is true' do
      let(:destroy_item) { true }

      it 'removes the line item' do
        expect { subject }.to change { order.line_items.pluck(:id) }.from([line_item.id]).to([])
      end
    end

    context 'when unknown line item id is provided' do
      before do
        line_item.destroy
      end

      it 'raises ActiveRecord::RecordNotFound' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '#autocomplete_user_information in before_create' do
    subject(:new_order) { user.orders.pending.create }

    let(:order_data) do
      {
        email: Faker::Internet.email,
        phone: '123456789',
        full_name: Faker::GameOfThrones.character,
        payment_method: 'cash',
        shipping_method: 'pickup',
        city: Faker::Lorem.word,
        street: Faker::Lorem.word
      }
    end
    let(:user_data) { { email: Faker::Internet.email, phone: '123456789', name: Faker::GameOfThrones.character } }

    context 'when previous order exists' do
      before do
        create(:order, order_data.merge(customer: user))
      end

      context 'when the customer is a persisted user' do
        let(:user) { create(:user, user_data) }

        it 'clones previous order data' do
          expect(new_order.as_json.with_indifferent_access).to include order_data
        end
      end

      context 'when the customer is a temporary user' do
        let(:user) { create(:temporary_user) }

        it 'clones previous order data' do
          expect(new_order.as_json.with_indifferent_access).to include order_data
        end
      end
    end

    context 'when there is no previous order' do
      context 'when the customer is persisted user' do
        let(:user) { create(:user, user_data) }

        it 'clones user data' do
          expect(new_order.as_json.with_indifferent_access).to include user_data.except(:name)
          expect(new_order.full_name).to eq user_data[:name]
        end
      end

      context 'when the customer is a temporary user' do
        let(:user) { create(:temporary_user) }

        it 'does not prefill user data' do
          expect(new_order.as_json.values_at(*%w(email full_name phone)).all?(&:nil?)).to eq true
        end
      end
    end
  end
end

describe '#apply_promo_code' do
  subject { order.apply_promo_code(code) }

  let(:promo_code) { create(:promo_code, discount_percent: 30) }
  let(:code) { promo_code.code }
  let(:order) { create(:order, :with_line_items) }

  it 'applies the discount' do
    initial_total = order.total

    expect { subject }.to change { order.reload.total }.from(initial_total).to(initial_total * 0.7)
  end

  context 'when the promo code does not exist' do
    let(:code) { 'what' }

    it 'adds an error' do
      subject

      expect(order.errors.details).to eq(base: [{ error: I18n.t('errors.messages.promo_code.blank') }])
    end

    it 'does not change the order total' do
      expect { subject }.not_to(change { order.reload.total })
    end
  end

  context 'when the promo code is expired' do
    let(:promo_code) { create(:promo_code, expires_at: 1.day.ago) }

    it 'adds an error' do
      subject

      expect(order.errors.details).to eq(base: [{ error: I18n.t('errors.messages.promo_code.expired') }])
    end
  end

  context 'when the promo code is exhausted' do
    let(:promo_code) { create(:promo_code, limit: 1, orders_count: 1) }

    it 'adds an error' do
      subject

      expect(order.errors.details).to eq(base: [{ error: I18n.t('errors.messages.promo_code.exhausted') }])
    end
  end
end
