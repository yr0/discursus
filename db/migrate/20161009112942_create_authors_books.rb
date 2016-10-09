class CreateAuthorsBooks < ActiveRecord::Migration[5.0]
  def change
    create_table :authors_books do |t|
      t.integer :author_id
      t.integer :book_id

      t.integer :position
    end

    add_index :authors_books, :author_id
    add_index :authors_books, :book_id
  end
end
