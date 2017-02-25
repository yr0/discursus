class OrdersController < ApplicationController
  # Fetch current user or create temporary user and fetch or create order for them - only on specific actions
  before_action :create_or_get_user_with_order!, only: %i(populate)
  before_action :initialize_order_submission, only: %i(cart submit_user)

  rescue_from Populating::OrderPopulatingError do |e|
    @error_message = e.message
    render 'warning'
  end

  def cart
  end

  def submit_user
    @user = @order_submission.user_for_order
    @user.assign_attributes(order_submission_params[:user_for_order])
    @errors = @user.errors.full_messages.uniq unless @user.valid?
  end

  def submit
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

  def initialize_order_submission
    @order_submission = OrderSubmission.new
  end

  def order_submission_params
    params.require(:order_submission).permit(user_for_order: %i(name phone email
                                                                password password_confirmation))
  end
end
