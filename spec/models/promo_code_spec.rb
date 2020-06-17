describe PromoCode do
  let(:promo_code) { create(:promo_code) }
  let(:code) { promo_code.code }

  describe '.find_by_code' do
    it 'finds the promo code by code' do
      expect(described_class.find_by_code(code)).to eq promo_code
    end

    it 'does not fail if promo code is nil' do
      expect(described_class.find_by_code(nil)).to be_nil
    end
  end

  describe '#expired?' do
    it 'returns false if promo code is not expired' do
      expect(promo_code.expired?).to eq false
    end

    it 'returns true if promo code is expired' do
      promo_code.update(expires_at: 1.second.ago)
      expect(promo_code.expired?).to eq true
    end
  end

  describe '#exhausted?' do
    it 'returns false if limit was not set' do
      new_code = create(:promo_code, limit: nil)
      expect(new_code.exhausted?).to eq false
    end

    it 'returns false if limit was set to 0' do
      new_code = create(:promo_code, limit: 0)
      expect(new_code.exhausted?).to eq false
    end

    it 'returns false if limit is not yet reached' do
      expect(promo_code.exhausted?).to eq false
    end

    it 'returns true if limit is reached' do
      new_code = create(:promo_code, limit: 1, orders_count: 1)
      expect(new_code.exhausted?).to eq true
    end
  end

  xdescribe '#used_by?' do
    let(:email) { Faker::Internet.email }

    it 'returns false if promo code was not used in order with provided email' do
      expect(promo_code.used_by?(email)).to eq false
    end

    it 'returns false if promo code was used in order that is in other state than completed' do
      create(:order, email: email, promo_code: promo_code)
      create(:order, :submitted, email: email, promo_code: promo_code)
      create(:order, :paid_for, email: email, promo_code: promo_code)
      expect(promo_code.used_by?(email)).to eq false
    end

    it 'returns true if promo code was used in completed order' do
      order = create(:order, :paid_for, email: email, promo_code: promo_code)
      order.success!
      expect(promo_code.used_by?(email)).to eq true
    end
  end

  context '#apply_discount' do
    it 'subtracts from amount discount percent' do
      new_code = create(:promo_code, discount_percent: 50)
      expect(new_code.apply_discount(200)).to eq 100
    end
  end
end
