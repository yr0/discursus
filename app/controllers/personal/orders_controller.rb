# frozen_string_literal: true

module Personal
  class OrdersController < PersonalController
    def index
      @orders = current_user.orders.where.not(status: :pending).order(created_at: :desc).page(params[:page])
    end

    def show
      @order = current_user.orders.find(params[:id])
    end
  end
end
