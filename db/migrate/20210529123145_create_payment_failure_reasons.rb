class CreatePaymentFailureReasons < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_failure_reasons do |t|
      t.bigint :payment_id, null: false
      t.string :reason, limit: 1000, null: false

      t.timestamps null: false
    end

    add_index :payment_failure_reasons, :payment_id
  end
end
