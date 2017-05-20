class AddFragmentFileToBooks < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :fragment_file, :string
  end
end
