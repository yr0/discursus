class PaymentsController < ApplicationController
  LIQPAY_FAIL_STATUSES = %w(failure error reversed).freeze

  protect_from_forgery except: :liqpay_callback

  # Liqpay will return here with payment result
  def liqpay_callback
    process_liqpay_response
  rescue Liqpay::InvalidResponse
    Rails.logger.fatal "Incorrect liqpay response received: #{try(:liqpay_response)}"
  ensure
    head :ok
  end

  private

  def process_liqpay_response
    liqpay_response = Liqpay::Response.new(params)
    load_and_check_order_from!(liqpay_response)
    if liqpay_success_statuses.include?(liqpay_response.status)
      @order.pay!
    else
      Rails.logger.fatal "Non-success liqpay response status for order #{@order.id}: #{liqpay_response.status}"
    end
  end

  def load_and_check_order_from!(liqpay_response)
    @order = Order.find_by(id: liqpay_response.order_id)
    unless @order.present? &&
           liqpay_response.amount == @order.total.to_f && liqpay_response.currency == Order::LIQPAY_CURRENCY
      Rails.logger.fatal 'Liqpay Response did not pass validations'
      raise Liqpay::InvalidResponse
    end
  end

  def liqpay_success_statuses
    Rails.configuration.liqpay_sandbox == 1 ? %w(success sandbox).freeze : %w(success).freeze
  end
end
