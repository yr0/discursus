module Personal
  class OrdersController < PersonalController
    def index
      @orders = current_user.orders.where.not(aasm_state: :pending).page(params[:page])
    end

    def show
      @order = current_user.orders.find(params[:id])
    end
  end
end
