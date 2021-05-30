# frozen_string_literal: true

describe OrdersFunctionality::Validations do
  describe 'must_have_email_or_phone' do
    it 'adds error if order is submitted and no email and no phone is present' do
      order = create(:order, :valid_for_user_swap, :with_line_items, email: nil, order_phone: nil, order_password: nil)
      expect(order.submit!).to eq false
      expect(order.errors.details).to eq(base: [{ error: :must_have_email_or_phone }])
    end

    it 'adds error if order form submission has started and no email and no phone is present' do
      order = build(:order, :with_line_items, email: nil, phone: nil, form_submission_started: true)
      expect(order).not_to be_valid
      expect(order.errors.details).to eq(base: [{ error: :must_have_email_or_phone }])
    end

    it 'adds error about email being required if user chose to provide password' do
      order = create(:order, :valid_for_user_swap, :with_line_items, email: nil, phone: nil)
      expect(order.submit!).to eq false
      expect(order.errors.details).to eq(base: [{ error: :email_presence_on_account }])
    end

    it 'adds error about email being required if order contains digital line items' do
      order = create(:order, :valid_for_user_swap, :with_line_items, book_variant: :audio, email: nil, phone: nil)
      expect(order.submit!).to eq false
      expect(order.errors.details).to eq(base: [{ error: :email_presence_on_digital }])
    end
  end

  describe 'email_must_be_unique' do
    let(:email) { Faker::Internet.email }

    it 'checks uniqueness of email if user chose to register with order by providing password' do
      create(:user, email: email)
      order = build(:order, email: email, password: '123123123')
      expect(order).not_to be_valid
      expect(order.errors.details).to eq(email: [{ error: :exists }])
    end

    it 'checks uniqueness on update' do
      create(:user, email: email)
      order = create(:order, :valid_for_user_swap)
      order.email = email
      expect(order).not_to be_valid
      expect(order.errors.details).to eq(email: [{ error: :exists }])
    end
  end
end
