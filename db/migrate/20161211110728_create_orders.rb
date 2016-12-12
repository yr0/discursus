class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.integer :customer_id
      t.integer :customer_type
      t.string :aasm_state
      t.text :failure_comment

      # total/payment
      t.decimal :total, precision: 8, scale: 2
      t.string :payment_method
      t.string :external_payment_id
      t.decimal :external_commissions, precision: 8, scale: 2

      # basics
      t.string :phone
      t.string :email
      t.string :full_name

      # shipment
      t.string :shipment_method
      t.string :shipping_service
      t.string :shipping_service_details
      t.text :shipping_address
      t.text :comment

      t.datetime :completed_at
      t.timestamps null: false
    end
  end
end
