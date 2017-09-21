class AddOrderFieldsToBooks < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :is_top, :boolean, default: false
    add_column :books, :published_at, :datetime, default: '01.01.2013'.to_datetime
  end
end
