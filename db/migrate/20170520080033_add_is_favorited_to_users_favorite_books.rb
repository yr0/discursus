class AddIsFavoritedToUsersFavoriteBooks < ActiveRecord::Migration[5.0]
  def change
    add_column :users_favorite_books, :is_favorited, :boolean, default: true
  end
end
