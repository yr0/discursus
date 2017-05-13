module AdminPanel
  class OrdersController < AdminPanelController
    authorize_resource
    load_resource except: %i(index)

    rescue_from AASM::InvalidTransition do
      head :bad_request
    end

    def index
      filter_query = {}
      if params[:aasm_state].present? &&
          Order.aasm.state_machine.states.map(&:name).include?(params[:aasm_state].to_sym)
        filter_query = { aasm_state: params[:aasm_state] }
      end

      @orders = Order.where.not(aasm_state: :pending).where(filter_query).order(submitted_at: :desc).page(params[:page])
    end

    def show
    end

    def complete
      @order.success!
      head :ok
    end

    # For orders that are to be paid in cash - submit marks the order having been paid
    def acknowledge_payment
      @order.pay!
      head :ok
    end
  end
end
