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

  describe 'promo validations' do
    let(:email) { Faker::Internet.email }

    it 'adds error if raw promo code is present and promo_code_id is blank' do
      # this means promo code could not be found
      order = create(:order)
      order.raw_promo_code = '123'
      expect(order).not_to be_valid
      expect(order.errors.details).to eq(base: [{ error: I18n.t('errors.messages.promo_code.blank') }])
    end

    it 'does not add absent promo error if order is not in pending state' do
      order = create(:order, :with_line_items)
      order.submit!
      order.raw_promo_code = '123'
      expect(order).to be_valid
    end

    # Disabled as per Vasyl's request
    xit 'adds error if a user with the same e-mail already made a purchase with this code' do
      promo = create(:promo_code, limit: 0)
      user = create(:user, email: email)
      order1, order2 = create_list(:order, 2, :with_line_items, customer: user)
      order1.raw_promo_code = promo.code
      order1.tap(&:submit!).tap(&:pay!).tap(&:success!)
      order2.raw_promo_code = promo.code
      expect(order2).not_to be_valid
      expect(order2.errors.details).to eq(base: [{ error: I18n.t('errors.messages.promo_code.already_used') }])
    end

    it 'adds error for the expired promo code' do
      promo = create(:promo_code, expires_at: 1.day.ago)
      order = create(:order)
      order.raw_promo_code = promo.code
      expect(order).not_to be_valid
      expect(order.errors.details).to eq(base: [{ error: I18n.t('errors.messages.promo_code.expired') }])
    end

    it 'adds error for promo code whose limit has been reached' do
      promo = create(:promo_code, limit: 1)
      order1, order2 = create_list(:order, 2, :with_line_items)
      order1.raw_promo_code = promo.code
      order1.tap(&:submit!).tap(&:pay!).tap(&:success!)
      order2.raw_promo_code = promo.code
      expect(order2).not_to be_valid
      expect(order2.errors.details).to eq(base: [{ error: I18n.t('errors.messages.promo_code.exhausted') }])
    end
  end
end
