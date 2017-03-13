class OrdersController < ApplicationController
  # Fetch current user or create temporary user and fetch or create order for them - only on specific actions
  before_action :create_or_get_user_with_order!, only: %i(populate)

  rescue_from Populating::OrderPopulatingError do |e|
    @error_message = e.message
    render 'warning'
  end

  def cart
  end

  # Called after submitting first/second (presubmit) and after third (submit) steps.
  # Presubmission runs all validations but doesn't store the order
  def submit
    @presubmit = params[:commit] != I18n.t('orders.submit')
    current_order.assign_attributes(order_submission_params)

    try_submitting_order unless @presubmit
    @errors ||= current_order.errors.full_messages.uniq unless current_order.valid?
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
                                  :full_name, :phone, :email, :password, :password_confirmation)
  end

  def try_submitting_order
    if verify_recaptcha(model: current_order)
      current_order.submit!
    else
      @errors = [I18n.t('recaptcha_failed')]
    end
  end
end
