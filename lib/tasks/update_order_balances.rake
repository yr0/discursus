# frozen_string_literal: true

desc 'Updates the balances of all open orders to their total'
task update_order_balances: :environment do
  Order.where(status: %i(pending submitted)).update_all('balance=total') # rubocop:disable Rails/SkipsModelValidations
end
