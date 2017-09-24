class AddTotalNoPromoToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :total_no_promo, :decimal, precision: 8, scale: 2
  end
end
