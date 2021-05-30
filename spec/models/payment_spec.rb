# frozen_string_literal: true

describe Payment do
  describe '#succeed' do
    subject { payment.succeed! }

    let(:payment) { create(:payment, order: order, amount: payment_amount) }
    let(:order) { create(:order, :submitted) }
    let(:payment_amount) { order.balance - 10 }

    it 'transitions payment to the new status' do
      expect { subject }.to change { payment.reload.status }.from('initiated').to('succeeded')
    end

    it 'recalculates the order balance' do
      expect { subject }.to change { order.reload.balance }.by(-payment_amount)
    end

    it 'does not change the status of the order' do
      expect { subject }.not_to(change { order.reload.status })
    end

    context 'when payment covers the order balance' do
      let(:payment_amount) { order.balance }

      it 'recalculates the order balance' do
        expect { subject }.to change { order.reload.balance }.to(0)
      end

      it 'changes the status of the order' do
        expect { subject }.to change { order.reload.status }.from('submitted').to('paid_for')
      end
    end
  end

  describe '#fail' do
    subject { payment.fail!(failure_reason) }

    let(:payment) { create(:payment, order: order) }
    let(:order) { create(:order, :submitted) }
    let(:failure_reason) { 'Insufficient funds' }

    it 'transitions the payment to failed status' do
      expect { subject }.to change { payment.reload.status }.from('initiated').to('failed')
    end

    it 'does not change order balance or status' do
      expect { subject }.not_to(change { [order.reload.balance, order.status].join })
    end

    it 'persists the failure reason' do
      expect { subject }.to change { payment.reload.failure_reason&.reason }.from(nil).to(failure_reason)
    end

    context 'when payment cannot transition' do
      let(:payment) { create(:payment, order: order, status: 'succeeded') }

      it 'does not persist the failure reason' do
        expect { subject }.to raise_error(AASM::InvalidTransition)

        expect(payment.reload.failure_reason).to be_nil
      end
    end
  end
end
