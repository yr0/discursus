class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_order

  def current_temp_user
    @current_temp_user ||= TemporaryUser.find_by(uuid: cookies[:temp_user_uuid])
  end

  def current_order
    return @current_order if @current_order
    user = current_user || current_temp_user
    @current_order = user.orders.pending.first if user
  end

  private

  def create_or_get_user_with_order!
    Order.transaction do
      create_temp_user unless current_user
      user = current_user || current_temp_user
      @current_order = user.orders.pending.first_or_create
    end
  end

  def create_temp_user
    uuid = cookies[:temp_user_uuid] || SecureRandom.uuid
    @current_temp_user = TemporaryUser.find_or_create_by(uuid: uuid)
    cookies[:temp_user_uuid] = uuid
  end
end
