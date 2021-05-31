# frozen_string_literal: true

# rubocop:disable Metrics/ModuleLength
module Wayforpay
  Error = Class.new(RuntimeError)
  SignatureInvalidError = Class.new(Error)
  ResponseDataMismatchError = Class.new(Error)

  PAYMENT_URL = 'https://secure.wayforpay.com/pay'
  APPROVED_TRANSACTION_STATUS = 'approved'
  APPROVED_REASON = 'ok'
  CHECKED_RESPONSE_PARAM_KEYS = %i(merchantAccount orderReference amount currency authCode cardPan
                                   transactionStatus reasonCode).freeze
  ACCEPT_RESPONSE_TEXT = 'accept'
  ORDER_REFERENCE_PREFIX = 'DSC-'
  PAYMENT_REFERENCE_PREFIX = 'PAY-'

  class << self
    def configure
      @config ||= {}
      yield @config
    end

    def prepare_params_from(payment)
      base_params = base_params_array_for(payment)
      signature = generate_signature_from(base_params.map(&:last).flatten)
      base_params.to_h.merge('merchantSignature' => signature).merge(additional_payment_params_for(payment.order))
    end

    def process_and_produce_message_for(params)
      if params[:orderReference].starts_with?(ORDER_REFERENCE_PREFIX)
        order = validate_and_find_order_from!(params)

        process_message_for(order, params)
      else
        payment = validate_and_find_payment_from!(params)

        process_message_for_payment(payment, params)
      end

      generate_response_message_for(params[:orderReference])
    end

    def was_payment_successful?(params)
      if params[:orderReference].starts_with?(ORDER_REFERENCE_PREFIX)
        validate_and_find_order_from!(params)
      else
        validate_and_find_payment_from!(params)
      end

      params[:transactionStatus]&.downcase == APPROVED_TRANSACTION_STATUS &&
        params[:reason]&.downcase == APPROVED_REASON
    end

    private

    def generate_signature_from(elements)
      payload = elements.join(';')
      OpenSSL::HMAC.hexdigest('md5', @config.fetch(:key), payload)
    end

    def verify_signature_for!(suggested_signature, elements)
      payload = elements.join(';')
      true_signature = OpenSSL::HMAC.hexdigest('md5', @config.fetch(:key), payload)

      return if true_signature == suggested_signature

      raise SignatureInvalidError
    end

    def base_params_array_for(payment)
      base_params = [
        ['merchantAccount', @config.fetch(:merchant_account)],
        ['merchantDomainName', @config.fetch(:merchant_domain)],
        ['orderReference', "#{PAYMENT_REFERENCE_PREFIX}#{payment.id}"],
        ['orderDate', payment.created_at.to_i],
        ['amount', payment.amount.to_f],
        ['currency', @config.fetch(:acceptable_currency)]
      ]

      base_params + products_spec_per(payment.order)
    end

    def additional_payment_params_for(order)
      {
        'language' => 'UA',
        'returnUrl' => Rails.application.routes.url_helpers.wayforpay_redirect_url,
        'serviceUrl' => Rails.application.routes.url_helpers.wayforpay_callback_url,
        'clientEmail' => order.email,
        'clientPhone' => order.phone
      }
    end

    def products_spec_per(order)
      product_names = []
      product_counts = []
      product_prices = []

      order.line_items.includes(:book).each do |item|
        product_names << item.book.title
        product_counts << item.quantity
        product_prices << item.price.to_f
      end

      [
        ['productName', product_names],
        ['productCount', product_counts],
        ['productPrice', product_prices]
      ]
    end

    # rubocop:disable Metrics/AbcSize
    # The commands in this module can be extracted into separate classes
    def validate_and_find_order_from!(params)
      verify_signature_for!(params[:merchantSignature], params.slice(*CHECKED_RESPONSE_PARAM_KEYS).values)

      order = Order.find(params[:orderReference].tr(ORDER_REFERENCE_PREFIX, ''))

      return order if
        params[:amount].to_f == order.total.to_f && params[:currency] == @config.fetch(:acceptable_currency)

      raise ResponseDataMismatchError, params.inspect
    end
    # rubocop:enable all

    # rubocop:disable Metrics/AbcSize
    # The commands in this module can be extracted into separate classes
    def validate_and_find_payment_from!(params)
      verify_signature_for!(params[:merchantSignature], params.slice(*CHECKED_RESPONSE_PARAM_KEYS).values)

      payment = Payment.find(params[:orderReference].tr(PAYMENT_REFERENCE_PREFIX, ''))

      return payment if
        params[:amount].to_f == payment.amount.to_f && params[:currency] == @config.fetch(:acceptable_currency)

      raise ResponseDataMismatchError, params.inspect
    end
    # rubocop:enable all

    # rubocop:disable Metrics/AbcSize
    # The commands in this module can be extracted into separate classes
    def process_message_for(order, params)
      if params[:transactionStatus]&.downcase == APPROVED_TRANSACTION_STATUS &&
         params[:reason]&.downcase == APPROVED_REASON
        order.pay!
      else
        reason = params.slice(:transactionStatus, :reason, :reasonCode).values.join(';')
        order.fail
        order.update!(failure_comment: [order.failure_comment, reason].compact.join('. '))

        Rails.logger.error "Non-success wayforpay response status for order #{order.id}: #{reason}"
      end
    end
    # rubocop:enable all

    def process_message_for_payment(payment, params)
      if params[:transactionStatus]&.downcase == APPROVED_TRANSACTION_STATUS &&
         params[:reason]&.downcase == APPROVED_REASON
        payment.succeed!
      else
        reason = params.slice(:transactionStatus, :reason, :reasonCode).values.join(';')
        payment.fail!(reason)

        Rails.logger.error "Non-success wayforpay response status for payment #{payment.id}"
      end
    end

    def generate_response_message_for(reference)
      base_params = [
        ['orderReference', reference],
        ['status', ACCEPT_RESPONSE_TEXT],
        ['time', Time.current.to_i]
      ]

      signature = generate_signature_from(base_params.map(&:last).flatten)

      base_params.to_h.merge('signature' => signature)
    end
  end
end
