class OrderMailer < ApplicationMailer
  # Notifies user about order with instructions on how to pay with cash
  def notify_cash(order)
    @order = order
    mail(to: order.customer.email, subject: I18n.t('mailers.order.subject', id: order.id))
  end

  # Notifies user about paid order (since it is paid with card)
  def notify_card(order)
    @order = order
    mail(to: order.customer.email, subject: I18n.t('mailers.order.subject', id: order.id))
  end
end
