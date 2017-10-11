Liqpay.default_options = {
  public_key: Rails.application.secrets.liqpay['public'],
  private_key: Rails.application.secrets.liqpay['private'],
  currency: Order::LIQPAY_CURRENCY
}
