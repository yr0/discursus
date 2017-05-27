class AddIsUsedToTokens < ActiveRecord::Migration[5.0]
  def change
    add_column :tokens_for_digital_books, :is_used, :boolean, default: false
  end
end
