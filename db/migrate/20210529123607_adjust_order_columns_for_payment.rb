class AdjustOrderColumnsForPayment < ActiveRecord::Migration[5.2]
  def change
    remove_column :orders, :external_payment_id, :string
    remove_column :orders, :external_commissions, :decimal, precision: 8, scale: 2

    add_column :orders, :balance, :decimal, precision: 8, scale: 2, default: 0
    rename_column :orders, :aasm_state, :status
  end
end
