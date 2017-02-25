class AddColumnsToOrder < ActiveRecord::Migration[5.0]
  def change
    rename_column :orders, :shipment_method, :shipping_method
    add_column :orders, :city, :string
    add_column :orders, :street, :string
    remove_column :orders, :shipping_address
  end
end
