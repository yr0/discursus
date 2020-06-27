Wayforpay.configure do |config|
  config[:merchant_account] = Rails.application.secrets.wayforpay['merchant_account']
  config[:merchant_domain] = ENV['DISCURSUS_HOST']
  config[:acceptable_currency] = 'UAH'

  config[:key] = Rails.application.secrets.wayforpay['key']
end
