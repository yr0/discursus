class CreateBooksSeries < ActiveRecord::Migration[5.0]
  def change
    create_table :books_series do |t|
      t.belongs_to :book
      t.belongs_to :series
    end
  end
end
