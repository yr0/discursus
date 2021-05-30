# frozen_string_literal: true

describe Wayforpay do
  let(:merchant_account) { 'merchantAccountId' }
  let(:merchant_domain) { 'discursus.com' }
  let(:acceptable_currency) { 'UAH' }
  let(:wayforpay_key) { 'asdasdasd123123' }

  before(:all) do
    described_class.configure do |config|
      config[:merchant_account] = 'merchantAccountId'
      config[:merchant_domain] = 'discursus.com'
      config[:acceptable_currency] = 'UAH'
      config[:key] = 'asdasdasd123123'
    end
  end

  describe '.configure' do
    subject { described_class.configure { |config| config[config_key] = config_value } }

    let(:config_key) { :some_var }
    let(:config_value) { 'hello' }

    it 'changes the config variable' do
      expect { subject }
        .to change { described_class.instance_variable_get(:@config)[config_key] }.from(nil).to(config_value)
    end
  end

  describe '.prepare_params_from' do
    subject(:prepare_params) { described_class.prepare_params_from(payment) }

    let(:payment) { create(:payment, order: order, amount: order.total) }
    let(:order) { create(:order, :submitted) }

    it 'generates correct params from merchant config' do
      expect(prepare_params).to include(
        'merchantAccount' => merchant_account,
        'merchantDomainName' => merchant_domain,
        'currency' => acceptable_currency
      )
    end

    it 'generates correct params from order itself' do
      expect(prepare_params).to include(
        'orderReference' => "PAY-#{payment.id}",
        'orderDate' => payment.created_at.to_i,
        'amount' => payment.amount,
        'clientEmail' => order.email,
        'clientPhone' => order.phone
      )
    end

    it 'generates correct params from order items' do
      expect(prepare_params).to include(
        'productName' => order.line_items.map { |item| item.book.title },
        'productCount' => order.line_items.pluck(:quantity),
        'productPrice' => order.line_items.pluck(:price)
      )
    end

    it 'adds correct additional info to the params' do
      expect(prepare_params).to include(
        'language' => 'UA',
        'returnUrl' => Rails.application.routes.url_helpers.wayforpay_redirect_url,
        'serviceUrl' => Rails.application.routes.url_helpers.wayforpay_callback_url
      )
    end

    describe 'adding signature' do
      let(:signature_parts) do
        [
          merchant_account, merchant_domain, "PAY-#{payment.id}", payment.created_at.to_i, payment.amount,
          acceptable_currency, order.line_items.map { |item| item.book.title }, order.line_items.pluck(:quantity),
          order.line_items.pluck(:price)
        ].flatten
      end
      let(:signature) { 'abcd123' }

      before do
        allow(OpenSSL::HMAC).to receive(:hexdigest).and_return(signature)
      end

      it 'calls hexdigest with correct params' do
        prepare_params

        expect(OpenSSL::HMAC).to have_received(:hexdigest).with('md5', wayforpay_key, signature_parts.join(';'))
      end

      it 'adds correct signature to the params' do
        expect(prepare_params).to include('merchantSignature' => signature)
      end
    end
  end

  shared_context 'wayforpay response' do
    let(:params) do
      {
        merchantAccount: merchant_account,
        orderReference: params_order_reference,
        amount: params_amount,
        currency: params_currency,
        authCode: params_auth_code,
        cardPan: params_card_pan,
        transactionStatus: params_transaction_status,
        reasonCode: params_reason_code,
        reason: params_reason,
        merchantSignature: params_signature
      }
    end
    let(:params_order_reference) { "DSC-#{order.id}" }
    let(:params_amount) { order.total }
    let(:params_currency) { acceptable_currency }
    let(:params_auth_code) { '123456' }
    let(:params_card_pan) { '42****4242' }
    let(:params_transaction_status) { 'Approved' }
    let(:params_reason_code) { '1100' }
    let(:params_reason) { 'Ok' }
    let(:params_signature) { true_signature }
    let(:true_signature) { 'asdasd123123' }

    before do
      allow(OpenSSL::HMAC).to receive(:hexdigest).and_return true_signature
    end
  end

  shared_examples_for 'verifying wayforpay response' do
    context 'when signature is incorrect' do
      let(:params_signature) { '123123' }

      it 'raises an error' do
        expect { subject }.to raise_error(described_class::SignatureInvalidError)
      end
    end

    context 'when provided amount is incorrect' do
      let(:params_amount) { 0.0 }

      it 'raises an error' do
        expect { subject }
          .to raise_error(described_class::ResponseDataMismatchError, a_kind_of(String))
      end
    end

    context 'when provided currency is incorrect' do
      let(:params_currency) { 'USD' }

      it 'raises an error' do
        expect { subject }
          .to raise_error(described_class::ResponseDataMismatchError, a_kind_of(String))
      end
    end
  end

  describe '.process_and_produce_message_for' do
    subject(:process_and_produce_message) { described_class.process_and_produce_message_for(params) }

    let!(:order) { create(:order, :submitted) }

    include_context 'wayforpay response'
    it_behaves_like 'verifying wayforpay response'

    it 'transitions order to paid_for state' do
      expect { process_and_produce_message }.to change { order.reload.status }.from('submitted').to('paid_for')
    end

    it 'generates correct message in response' do
      expect(process_and_produce_message).to include(
        'orderReference' => params_order_reference,
        'status' => 'accept',
        'time' => be_an(Integer),
        'signature' => be_a(String)
      )
    end

    shared_examples_for 'handling non-success response' do
      before do
        allow(Rails.logger).to receive(:error)
      end

      it 'updates the order failure_comment' do
        expect { process_and_produce_message }.to change { order.reload.failure_comment }.from(nil).to(
          [params_transaction_status, params_reason, params_reason_code].join(';')
        )
      end

      it 'transitions order to failed state' do
        expect { process_and_produce_message }.to change { order.reload.status }.from('submitted').to('failed')
      end

      it 'generates correct message in response' do
        expect(process_and_produce_message).to include(
          'orderReference' => params_order_reference,
          'status' => 'accept',
          'time' => be_an(Integer),
          'signature' => be_a(String)
        )
      end

      it 'logs an error' do
        process_and_produce_message

        expect(Rails.logger).to have_received(:error).with(/Non-success wayforpay/)
      end
    end

    context 'when transactionStatus is not approved' do
      let(:params_transaction_status) { 'rejected' }

      it_behaves_like 'handling non-success response'
    end

    context 'when reason is not Ok' do
      let(:params_reason) { 'Nok' }

      it_behaves_like 'handling non-success response'
    end

    context 'when the response is for payment' do
      let(:payment) { create(:payment, order: order, amount: order.total) }

      let(:params_order_reference) { "PAY-#{payment.id}" }
      let(:params_amount) { payment.amount }

      it_behaves_like 'verifying wayforpay response'

      it 'transitions order to paid_for state' do
        expect { process_and_produce_message }.to change { order.reload.status }.from('submitted').to('paid_for')
      end

      it 'updates the order balance' do
        expect { process_and_produce_message }.to change { order.reload.balance }.from(payment.amount).to(0)
      end

      it 'updates the payment status' do
        expect { process_and_produce_message }.to change { payment.reload.status }.from('initiated').to('succeeded')
      end

      it 'generates correct message in response' do
        expect(process_and_produce_message).to include(
          'orderReference' => params_order_reference,
          'status' => 'accept',
          'time' => be_an(Integer),
          'signature' => be_a(String)
        )
      end

      shared_examples_for 'handling non-success response' do
        before do
          allow(Rails.logger).to receive(:error)
        end

        it 'updates the payment failure reason' do
          expect { process_and_produce_message }.to change { payment.reload.failure_reason&.reason }.from(nil).to(
            [params_transaction_status, params_reason, params_reason_code].join(';')
          )
        end

        it 'transitions payment to failed state' do
          expect { process_and_produce_message }.to change { payment.reload.status }.from('initiated').to('failed')
        end

        it 'transitions order to pending state' do
          expect { process_and_produce_message }.to change { order.reload.status }.from('submitted').to('pending')
        end

        it 'generates correct message in response' do
          expect(process_and_produce_message).to include(
            'orderReference' => params_order_reference,
            'status' => 'accept',
            'time' => be_an(Integer),
            'signature' => be_a(String)
          )
        end

        it 'logs an error' do
          process_and_produce_message

          expect(Rails.logger).to have_received(:error).with(/Non-success wayforpay/)
        end
      end

      context 'when transactionStatus is not approved' do
        let(:params_transaction_status) { 'rejected' }

        it_behaves_like 'handling non-success response'
      end

      context 'when reason is not Ok' do
        let(:params_reason) { 'Nok' }

        it_behaves_like 'handling non-success response'
      end
    end
  end

  describe '.was_payment_successful?' do
    subject(:was_payment_successful) { described_class.was_payment_successful?(params) }

    let!(:order) { create(:order, :submitted) }

    include_context 'wayforpay response'
    it_behaves_like 'verifying wayforpay response'

    it { is_expected.to eq true }

    context 'when transactionStatus is not approved' do
      let(:params_transaction_status) { 'rejected' }

      it { is_expected.to eq false }
    end

    context 'when reason is not Ok' do
      let(:params_reason) { 'Nok' }

      it { is_expected.to eq false }
    end

    context 'when the response is for payment' do
      let(:payment) { create(:payment, order: order, amount: order.total) }

      let(:params_order_reference) { "PAY-#{payment.id}" }
      let(:params_amount) { payment.amount }

      it_behaves_like 'verifying wayforpay response'

      it { is_expected.to eq true }

      context 'when transactionStatus is not approved' do
        let(:params_transaction_status) { 'rejected' }

        it { is_expected.to eq false }
      end

      context 'when reason is not Ok' do
        let(:params_reason) { 'Nok' }

        it { is_expected.to eq false }
      end
    end
  end
end
