class CreateLineItems < ActiveRecord::Migration[5.0]
  def change
    create_table :line_items do |t|
      t.integer :book_id
      t.integer :order_id
      t.string :variant
      t.decimal :price, precision: 8, scale: 2
      t.integer :quantity
    end

    add_index :line_items, :book_id
    add_index :line_items, :order_id
  end
end
