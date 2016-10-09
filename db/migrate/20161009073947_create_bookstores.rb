class CreateBookstores < ActiveRecord::Migration[5.0]
  def change
    create_table :bookstores do |t|
      t.string :title
      t.text :description
      t.string :image
      t.text :location_name
      t.decimal :location_lat, precision: 15, scale: 10
      t.decimal :location_lng, precision: 15, scale: 10

      t.timestamps null: false
    end
  end
end
