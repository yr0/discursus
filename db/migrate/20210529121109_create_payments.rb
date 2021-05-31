class CreatePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payments do |t|
      t.bigint :order_id, null: false
      t.decimal :amount, precision: 8, scale: 2, null: false
      t.string :status, limit: 30, default: 'initiated', null: false
      t.string :payment_method, limit: 30, null: false

      t.timestamps null: false
    end

    add_index :payments, [:order_id, :status]
  end
end
