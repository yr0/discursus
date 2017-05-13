class AddSubmittedAtToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :submitted_at, :datetime
  end
end
