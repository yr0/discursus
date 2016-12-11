class AddIsAvailableToBooks < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :is_available, :boolean, default: false
  end
end
