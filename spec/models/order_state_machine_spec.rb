context 'state machine' do
  include ActiveJob::TestHelper

  it 'is created in initial pending state' do
    expect(create(:order).pending?).to eq true
  end

  context 'submit' do
    it 'cannot be submitted if no line items are present' do
      order = create(:order)
      expect { order.submit! }.to raise_error(AASM::InvalidTransition)
    end

    it 'persists customer as user if order was created with temp user on submit' do
      order = create(:order, :with_line_items, :valid_for_user_swap)
      expect(order.customer).to be_a TemporaryUser
      expect do
        order.submit!
      end.to change { User.count }.by 1
    end

    it 'stores order data with created user after swap' do
      order = create(:order, :with_line_items, :valid_for_user_swap, order_password: 'orderpassword')
      email = order.email
      full_name = order.full_name
      phone = order.phone
      order.submit!
      customer = order.reload.customer
      expect(customer).to be_a User
      expect(customer.email).to eq email
      expect(customer.valid_password?('orderpassword')).to eq true
      expect(customer.name).to eq full_name
      expect(customer.phone).to eq phone
    end

    it 'destroys temp user when swapping order' do
      order = create(:order, :with_line_items, :valid_for_user_swap)
      expect do
        order.submit!
      end.to change { TemporaryUser.count }.by(-1)
    end

    it 'sends out user and admin notification if order is marked as paid in cash' do
      order = create(:order, :cash, :with_line_items, :valid_for_user_swap)

      expect { order.submit! }.to initiate_email_subjects(I18n.t('mailers.order.subject', id: order.id),
                                                          I18n.t('mailers.order.notify_admin.subject', id: order.id))
    end
  end

  context 'pay' do
    it 'transfers vote to paid state after being submitted and paid' do
      order = create(:order, :submitted)
      order.pay!
      expect(order.paid_for?).to eq true
    end

    it 'sends out user notification if order is marked as paid by card' do
      order = create(:order, :card, :submitted)
      expect { order.pay! }.to initiate_email_subjects(I18n.t('mailers.order.subject', id: order.id),
                                                       I18n.t('mailers.order.notify_admin.subject', id: order.id))
    end
  end

  context 'complete' do
    it 'cannot transition to completed after being submitted if order is paid by cash' do
      order = create(:order, :cash, :submitted)
      expect { order.success! }.to raise_error(AASM::InvalidTransition)
    end

    it 'can transition to completed after being paid if order is paid by card' do
      order = create(:order, :card, :paid_for)
      order.success!
      expect(order.completed?).to eq true
    end

    it 'can transition to completed after being paid if order is paid by card' do
      order = create(:order, :cash, :paid_for)
      order.success!
      expect(order.completed?).to eq true
    end

    it 'cannot transition to completed after being submitted if order is paid by card' do
      order = create(:order, :card, :submitted)
      expect { order.success! }.to raise_error(AASM::InvalidTransition)
    end

    it 'sets completed date after completion' do
      order = create(:order, :paid_for)
      order.success!
      expect(order.completed_at).to be
    end
  end
end
