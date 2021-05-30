class CreatePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payments do |t|
      t.bigint :order_id
      t.decimal :amount, precision: 8, scale: 2
      t.string :status, limit: 30, default: 'initiated'
      t.string :payment_type, limit: 30

      t.timestamps null: false
    end

    add_index :payments, [:order_id, :status]
  end
end
