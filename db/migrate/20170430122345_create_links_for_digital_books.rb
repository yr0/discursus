class CreateLinksForDigitalBooks < ActiveRecord::Migration[5.0]
  def change
    create_table :tokens_for_digital_books do |t|
      t.string :code
      t.string :variant
      t.integer :order_id
      t.integer :book_id
      t.integer :downloads_count, default: 0

      t.timestamps null: false
    end

    add_index :tokens_for_digital_books, :code
    add_index :tokens_for_digital_books, :order_id
    add_index :tokens_for_digital_books, :book_id
  end
end
