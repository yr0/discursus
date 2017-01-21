class OrdersController < ApplicationController
  # Fetch current user or create temporary user and fetch or create order for them - only on specific actions
  before_action :create_or_get_user_with_order!, only: %w(cart populate)

  rescue_from ActiveRecord::RecordNotSaved do |e|
    @error_message = e.message
    render 'warning'
  end

  def cart
  end

  # params: :book_id, :variant, :subtract (default false), :quantity (default 1)
  def populate
    current_order.populate!(params[:book_id], params[:variant])
  end
end
