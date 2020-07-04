class OrderMailer < ApplicationMailer
  add_template_helper PersonalHelper

  # Notifies user about order with instructions on how to pay with cash
  def notify_cash(order)
    @order = order
    mail(to: order.email, subject: I18n.t('mailers.order.subject', id: order.id))
  end

  # Notifies user about paid order (since it is paid with card)
  def notify_card(order)
    @order = order
    mail(to: order.email, subject: I18n.t('mailers.order.subject', id: order.id))
  end

  # Sends notification to admin email if it is present
  def notify_admin(order)
    admin_email = Rails.configuration.admin_email
    return if admin_email.blank?

    @order = order
    @orders_count = order.customer.orders.completed.count
    @orders_sum = order.customer.orders.completed.sum(:total)

    mail(to: admin_email, subject: I18n.t('mailers.order.notify_admin.subject', id: @order.id))
  end

  # Sends out links to digital copies of books to customer
  def digital_books(order)
    @order = order
    mail(to: order.email, subject: I18n.t('mailers.order.digital_books.subject', id: @order.id))
  end
end
