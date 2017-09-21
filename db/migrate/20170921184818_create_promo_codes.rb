class CreatePromoCodes < ActiveRecord::Migration[5.0]
  def change
    create_table :promo_codes do |t|
      t.string :code
      t.datetime :expires_at
      t.integer :limit
      t.integer :orders_count
      t.integer :discount_percent

      t.timestamps null: false
    end

    add_index :promo_codes, :code
  end
end
