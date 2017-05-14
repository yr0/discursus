module PersonalHelper
  PAGE_NAMES = {
      bookshelf: I18n.t('personal.nav.bookshelf'),
      orders: I18n.t('personal.nav.orders'),
      favorite_books: I18n.t('personal.nav.favorite'),
      profile: I18n.t('personal.nav.profile')
  }.freeze

  ORDER_DETAILS_FIELDS = %w(full_name phone email payment_method shipping_method city street comment).freeze

  def current_personal_page
    PAGE_NAMES[controller_name.to_sym]
  end

  def personal_order_description(order)
    data = "#{I18n.t('orders.order')} ##{order.id} (#{readable_date(order.submitted_at, true)})<br/>"\
    "#{I18n.t('orders.cart.short_description.total_items')}&nbsp;<b>#{order.line_items.size}</b><br/>"\
    "#{I18n.t('orders.cart.short_description.total_sum')}&nbsp;<b>#{readable_price(order.total)}</b>"
    data += "<br/>#{I18n.t('personal.orders.completed', date: readable_date(order.completed_at, true))}" if
        order.completed?
    data.html_safe
  end

  def personal_order_detailed_information(order)
    ORDER_DETAILS_FIELDS.map do |field|
      value = order[field]
      next unless value.present?
      if field == 'payment_method'
        value = I18n.t("orders.payment_methods.#{value}")
      elsif field == 'shipping_method'
        value = I18n.t("orders.shipping_methods.#{value}")
      end

      "<b>#{I18n.t("attributes.#{field}")}</b>: #{value}"
    end.compact.join('<br/>').html_safe
  end
end
