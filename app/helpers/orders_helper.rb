module OrdersHelper
  def user_for_order_contacts(order)
    contacts = %i(name email phone).select { |contact| order[contact].present? }.map do |contact|
      "#{I18n.t("orders.order_submission.summary.contact_data.#{contact}")} - #{order[contact]}"
    end.join(', ')
    contacts += ". #{t('orders.order_submission.summary.contact_data.registration')}" if order.password.present?
    contacts + '.'
  end

  def tab_number_from_errors
    if current_order.has_user_errors?
      0
    elsif current_order.has_recaptcha_error?
      2
    else
      1
    end
  end
end