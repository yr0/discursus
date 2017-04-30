module CurrentOrder
  extend ActiveSupport::Concern

  included do
    helper_method :current_order
  end

  def current_order
    return @current_order if @current_order
    user = current_user || current_temp_user
    @current_order = user.orders.pending.first if user
  end

  def current_temp_user
    @current_temp_user ||= TemporaryUser.find_by(uuid: cookies[:temp_user_uuid])
  end

  private

  def create_or_get_user_with_order!
    Order.transaction do
      create_temp_user unless current_user
      user = current_user || current_temp_user
      @current_order = user.orders.pending.first_or_create
    end
  end

  # If uuid cookie is present, fetches the temporary user from database
  # Otherwise, creates temp user if cookie is wrong or absent and writes the uuid into cookie.
  def create_temp_user
    if cookies[:temp_user_uuid].present?
      @current_temp_user = TemporaryUser.find_by(uuid: cookies[:temp_user_uuid])
      return if @current_temp_user.present?
    end

    uuid = SecureRandom.uuid
    @current_temp_user = TemporaryUser.create(uuid: uuid)
    cookies[:temp_user_uuid] = uuid
  end
end
