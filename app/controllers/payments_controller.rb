# frozen_string_literal: true

class PaymentsController < ApplicationController
  protect_from_forgery except: %i(wayforpay_callback wayforpay_redirect)

  def wayforpay_callback
    message = Wayforpay.process_and_produce_message_for(processed_wayforpay_params)

    render json: message
  end

  def wayforpay_redirect
    if Wayforpay.was_payment_successful?(params.to_unsafe_h.deep_symbolize_keys)
      redirect_to orders_thank_you_path
    else
      redirect_to orders_payment_failed_path
    end
  rescue Wayforpay::Error
    redirect_to root_path
  end

  private

  def processed_wayforpay_params
    params_keys = params.to_unsafe_h.keys
    wayforpay_key = params_keys.find { |key| key.match(/merchantAccount/) }

    raise 'No wayforpay payload found' if wayforpay_key.nil?

    JSON.parse(wayforpay_key).deep_symbolize_keys
  end
end
