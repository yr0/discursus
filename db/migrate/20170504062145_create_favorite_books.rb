class CreateFavoriteBooks < ActiveRecord::Migration[5.0]
  def change
    create_table :users_favorite_books do |t|
      t.integer :user_id
      t.integer :book_id

      t.timestamps null: false
    end

    add_index :users_favorite_books, :user_id
    add_index :users_favorite_books, :book_id
  end
end
