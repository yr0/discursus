# frozen_string_literal: true

class OrdersController < ApplicationController
  # Fetch current user or create temporary user and fetch or create order for them - only on specific actions
  before_action :create_or_get_user_with_order!, only: %i(populate)

  rescue_from Populating::OrderPopulatingError do |e|
    @error_message = e.message
    render 'warning'
  end

  def cart; end

  # Called after submitting first/second (presubmit) and after third (submit) steps.
  # Presubmission runs all validations but doesn't submit the order
  def submit
    @presubmit = params[:commit] != I18n.t('orders.submit')
    apply_attributes_to_order

    try_submitting_order unless @presubmit
    process_order_errors
  end

  def populate
    current_order.populate(params[:book_id], params[:variant])
  end

  # params: :book_id, :variant, :subtract (default false), :destroy (default false)
  def modify_line_item_quantity
    if current_order
      @line_item = current_order.modify_line_item_quantity(params[:id], params[:subtract].blank?,
                                                           params[:destroy].present?)
    else
      render json: { error: 'No order present' }
    end
  end

  private

  def order_submission_params
    params.require(:order).permit(:shipping_method, :city, :street, :payment_method, :comment,
                                  :full_name, :phone, :email, :password, :password_confirmation,
                                  :raw_promo_code)
  end

  def apply_attributes_to_order
    current_order.assign_attributes(order_submission_params.merge(form_submission_started: true))

    return unless order_submission_params.key?(:raw_promo_code)

    current_order.apply_promo_code(order_submission_params[:raw_promo_code])
  end

  def process_order_errors
    return if current_order.valid?

    @errors ||= current_order.errors.full_messages.uniq
    current_order.form_submission_started = false
  end

  def try_submitting_order
    if Rails.configuration.disable_recaptcha || verify_recaptcha(model: current_order)
      payment = submit_order_with_payment
      redirect_on_submission(payment)
    else
      @recaptcha_error = true
      @errors = [I18n.t('recaptcha_failed')]
    end
  end

  def submit_order_with_payment
    payment = nil

    current_order.transaction do
      current_order.submit!
      payment = current_order.payments.create!(
        amount: current_order.total,
        payment_method: current_order.payment_method
      )
    end

    payment
  end

  def redirect_on_submission(payment)
    if payment.payment_method == 'card'
      @payment_provider_form_settings = {
        action: Wayforpay::PAYMENT_URL,
        attributes: Wayforpay.prepare_params_from(payment)
      }
    else
      redirect_to action: 'thank_you'
    end
  end
end
