class OrderSubmission
  include ActiveModel::Model

  attr_accessor *%i(user_for_order shipping_method city street payment_method comment order)

  def initialize(options, order)
    super(options)
    @options = options
    @order = order
  end

  def user_for_order=(options)
    @user_for_order ||= UserForOrder.new(options)
  end

  def presubmit
    @order.assign_attributes(order_params)
  end

  def submit
    p 'SUBMITTING'
    # @order.update!(order_params)
  end

  private

  def order_params
    @options.permit(*%i(shipping_method city street payment_method comment))
  end
end
