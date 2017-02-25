class OrderSubmission
  include ActiveModel::Model

  attr_accessor *%i(user_for_order shipping_method city street payment_method comment)

  def initialize
    @user_for_order ||= UserForOrder.new
  end
end
