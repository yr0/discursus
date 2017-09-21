class AddPromoFieldsToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :raw_promo_code, :string
    add_column :orders, :promo_code_id, :integer

    add_index :orders, :promo_code_id
  end
end
