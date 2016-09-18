class CreateBooks < ActiveRecord::Migration[5.0]
  def change
    create_table :books do |t|
      t.string :title
      t.string :unprocessed_image
      t.text :description
      t.integer :pages_amount
      t.string :cover_type
      t.decimal :price, precision: 8, scale: 2

      t.timestamps null: false
    end
  end
end
