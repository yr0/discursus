class RemoveYearFromBooks < ActiveRecord::Migration[5.0]
  def change
    remove_column :books, :year, :integer
  end
end
