class AddVariantFieldsToBooks < ActiveRecord::Migration[5.0]
  def change
    rename_column :books, :price, :main_price
    rename_column :books, :unprocessed_image, :image
    add_column :books, :available_variants, :json
    add_column :books, :ebook_file, :string
    add_column :books, :audio_file, :string
  end
end
