module OrdersHelper
  def user_for_order_contacts(user)
    contacts = %i(name email phone).select { |contact| user.send(contact).present? }.map do |contact|
      "#{I18n.t("orders.order_submission.summary.contact_data.#{contact}")} - #{user.send(contact)}"
    end.join(', ')
    contacts += ". #{t('orders.order_submission.summary.contact_data.registration')}" if user.password.present?
    contacts + '.'
  end
end
