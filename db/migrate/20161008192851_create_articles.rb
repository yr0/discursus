class CreateArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :body
      t.string :slug
      t.string :image

      t.timestamps null: false
    end

    add_index :articles, :slug, unique: true
  end
end
