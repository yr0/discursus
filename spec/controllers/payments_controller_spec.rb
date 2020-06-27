describe PaymentsController, type: :controller do
  let(:wayforpay_params) { { merchantAccount: 'acc_acc', orderReference: '123123' } }

  describe '#wayforpay_callback' do
    subject(:wayforpay_callback) { post('wayforpay_callback', params: post_params) }

    let(:post_params) { { wayforpay_params.to_json => nil } }
    let(:response_message) { { status: 'success' } }

    before do
      allow(Wayforpay).to receive(:process_and_produce_message_for).and_return(response_message)
    end

    it 'calls Wayforpay.process_and_produce_message_for with correct params' do
      wayforpay_callback

      expect(Wayforpay).to have_received(:process_and_produce_message_for).with(wayforpay_params)
    end

    describe 'response status' do
      subject { wayforpay_callback; response.status }

      it { is_expected.to eq 200 }
    end

    describe 'response body' do
      subject { wayforpay_callback; response.body }

      it { is_expected.to eq response_message.to_json }
    end

    context 'if wayforpay params are incorrect' do
      let(:post_params) { {} }

      it 'raises an error' do
        expect { wayforpay_callback }.to raise_error(RuntimeError, 'No wayforpay payload found')
      end
    end
  end

  describe '#wayforpay_redirect' do
    subject(:wayforpay_callback) { post('wayforpay_redirect', params: wayforpay_params) }

    let(:payment_successful_result) { true }

    before do
      allow(Wayforpay).to receive(:was_payment_successful?).and_return(payment_successful_result)
    end

    it { is_expected.to redirect_to(orders_thank_you_path) }

    context 'when result of payment is unsuccessful' do
      let(:payment_successful_result) { false }

      it { is_expected.to redirect_to(orders_payment_failed_path) }            
    end

    context 'when Wayforpay wrapper raises an error' do
      before do
        allow(Wayforpay).to receive(:was_payment_successful?).and_raise(Wayforpay::Error)
      end

      it { is_expected.to redirect_to(root_path) }
    end
  end
end
