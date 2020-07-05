# frozen_string_literal: true

module OrdersHelper
  def user_for_order_contacts(order)
    contacts = %i(full_name email phone).select { |contact| order[contact].present? }.map do |contact|
      "#{I18n.t("orders.order_submission.summary.contact_data.#{contact}")} - #{order[contact]}"
    end.join(', ')
    contacts += ". #{t('orders.order_submission.summary.contact_data.registration')}" if order.password.present?
    contacts + '.'
  end

  def tab_number_from_errors
    if current_order.user_errors?
      0
    elsif @recaptcha_error
      2
    else
      1
    end
  end

  def free_shipping?(order)
    settings.free_shipping_price_after.to_i.positive? && order.total >= settings.free_shipping_price_after.to_i
  end
end
