class CreateAuthors < ActiveRecord::Migration[5.0]
  def change
    create_table :authors do |t|
      t.string :name
      t.string :image
      t.string :slug
      t.integer :position
      t.text :short_description
      t.text :description

      t.timestamps null: false
    end

    add_index :authors, :slug, unique: true
  end
end
