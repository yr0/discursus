class CreateBookExtraImages < ActiveRecord::Migration[5.0]
  def change
    create_table :book_extra_images do |t|
      t.integer :book_id
      t.string :image
      t.integer :position
      t.string :title
    end

    add_index :book_extra_images, :book_id
  end
end
