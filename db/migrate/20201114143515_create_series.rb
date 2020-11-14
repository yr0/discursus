class CreateSeries < ActiveRecord::Migration[5.0]
  def change
    create_table :series do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.string :description, limit: 10_000
      
      t.timestamps null: false
    end

    add_index :series, :slug, unique: true
  end
end
