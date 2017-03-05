class AddUserFieldsToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :password_digest, :string
  end
end
