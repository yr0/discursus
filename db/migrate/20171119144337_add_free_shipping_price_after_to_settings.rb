class AddFreeShippingPriceAfterToSettings < ActiveRecord::Migration[5.0]
  def change
    add_column :settings, :free_shipping_price_after, :integer
  end
end
