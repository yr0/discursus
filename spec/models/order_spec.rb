describe Order do
  context 'public instance methods' do
    context '#physical?,#requires_shipping?' do
      it 'returns true if order contains physical line items' do
        expect(create(:order, :with_line_items).physical?).to eq true
      end

      it 'returns true if order creates both physical and digital line items' do
        expect(create(:order, :digital_and_physical).physical?).to eq true
      end

      it 'returns false if order does not contain physical line items' do
        expect(create(:order, :with_line_items, book_variant: :ebook).physical?).to eq false
      end
    end

    context '#digital?' do
      it 'returns true if order contains digital items' do
        expect(create(:order, :with_line_items, book_variant: :ebook).digital?).to eq true
      end

      it 'returns true if order creates both physical and digital line items' do
        expect(create(:order, :digital_and_physical).digital?).to eq true
      end

      it 'returns false if order does not contain digital items' do
        expect(create(:order, :with_line_items).digital?).to eq false
      end
    end

    context '#address' do
      it 'returns order address as city and street joined by dot' do
        street = Faker::TwinPeaks.location
        city = Faker::Pokemon.location
        expect(create(:order, city: city, street: street).address).to eq "#{city}. #{street}"
      end

      it 'returns only city or street if one of them is not provided' do
        { street: Faker::TwinPeaks.location,
          city: Faker::Pokemon.location }.each do |key, value|
          expect(create(:order, key => value).address).to eq value
        end
      end
    end

    context '#recalculate_total' do
      it 'returns 0.0 if order has no line items' do
        order = create(:order)
        expect(order.recalculate_total).to be
        expect(order.reload.total).to eq 0.0
      end

      it 'calculates total as sum of order line items' do
        order = create(:order)
        line_item = create(:line_item, order: order)
        expect(order.recalculate_total).to be
        expect(order.total).to eq line_item.price * line_item.quantity
      end
    end

    context '#items?' do
      it 'returns true if line items are present' do
        expect(create(:order, :with_line_items).items?).to eq true
      end

      it 'returns false if line items are present' do
        expect(create(:order).items?).to eq false
      end
    end

    it '#populate populates order with book delegating to Populating#find_and_populate' do
      order = create(:order)
      book = create(:book, :hardcover)
      expect do
        order.populate(book.id, :hardcover)
      end.to change { order.line_items.count }.by 1
    end

    context '#modify_line_item_quantity' do
      let(:order) { create(:order) }
      let(:line_item) { create(:line_item, order: order, quantity: 2) }

      it 'increases amount of line item by 1 if increase is true' do
        line_item
        expect { order.modify_line_item_quantity(line_item.id, true) }.to change { line_item.reload.quantity }.by 1
      end

      it 'decreases amount of line item by 1 if increase is false' do
        line_item
        expect { order.modify_line_item_quantity(line_item.id, false) }.to change { line_item.reload.quantity }.by(-1)
      end

      it 'destroys item if destroy flag is provided' do
        line_item
        expect { order.modify_line_item_quantity(line_item.id, true, true) }.to change { order.line_items.count }.by(-1)
      end

      it 'raises ActiveRecord::RecordNotFound if line item cannot be found by id' do
        expect { order.modify_line_item_quantity(0, true) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context '#autocomplete_user_information' do
      let(:order_data) do
        { email: Faker::Internet.email, phone: '123456789', full_name: Faker::GameOfThrones.character,
          payment_method: 'cash', shipping_method: 'pickup', city: Faker::Lorem.word, street: Faker::Lorem.word }
      end
      let(:user_data) { { email: Faker::Internet.email, phone: '123456789', name: Faker::GameOfThrones.character } }
      let(:user) { create(:user, user_data) }
      let(:temp) { create(:temporary_user) }

      it 'clones previous order data after order is created for user' do
        order = create(:order, customer: user)
        order.update(order_data)
        new_order = user.orders.pending.create
        expect(new_order.as_json.with_indifferent_access).to include order_data
      end

      it 'clones previous order data after order is created for temp user' do
        order = create(:order, customer: temp)
        order.update(order_data)
        new_order = temp.orders.pending.create
        expect(new_order.as_json.with_indifferent_access).to include order_data
      end

      it 'clones user data if there is no previous order' do
        new_order = user.orders.pending.create
        expect(new_order.as_json.with_indifferent_access).to include user_data.except(:name)
        expect(new_order.full_name).to eq user_data[:name]
      end

      it 'does not clone user data if there is no previous order for temp user' do
        new_order = temp.orders.pending.create
        expect(new_order.as_json.values_at(*%w(email full_name phone)).all?(&:nil?)).to eq true
      end
    end
  end
end
