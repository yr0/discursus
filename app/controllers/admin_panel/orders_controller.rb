# frozen_string_literal: true

module AdminPanel
  class OrdersController < AdminPanelController
    authorize_resource
    load_resource except: %i(index)

    rescue_from AASM::InvalidTransition do
      render 'transition_error'
    end

    def index
      @orders = Order.where.not(status: %i(pending completed canceled))
                     .rewhere(filter_query).order(submitted_at: :desc).page(params[:page])
    end

    def show; end

    # For orders that are to be paid in cash - submit marks the order having been paid
    def acknowledge_payment
      @order.transaction do
        @order.payments.find_or_create_by(status: 'initiated', amount: @order.total, payment_method: 'cash').succeed!
      end
    end

    def complete
      @order.success!
    end

    def cancel
      @order.cancel!
    end

    private

    def filter_query
      if params[:status].present? &&
         Order.aasm.state_machine.states.map(&:name).include?(params[:status].to_sym)
        { status: params[:status] }
      else
        {}
      end
    end
  end
end
