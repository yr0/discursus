class AddFieldsToBooks < ActiveRecord::Migration[5.0]
  def change
    change_table :books do |t|
      t.text :cover_designer
      t.text :translator
      t.integer :year
      t.text :age_recommendations
      t.string :weight
      t.string :dimensions
      t.string :isbn
      t.text :authors_within_anthology
    end

    remove_column :books, :cover_type
  end
end
