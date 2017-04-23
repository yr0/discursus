class ChangeOrderCustomerTypeToString < ActiveRecord::Migration[5.0]
  def change
    change_column :orders, :customer_type, :string
  end
end
