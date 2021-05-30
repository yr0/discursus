class CreatePaymentFailureReasons < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_failure_reasons do |t|
      t.bigint :payment_id
      t.string :reason, limit: 1000

      t.timestamps null: false
    end
  end
end
