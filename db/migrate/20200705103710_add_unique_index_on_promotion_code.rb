class AddUniqueIndexOnPromotionCode < ActiveRecord::Migration[5.0]
  def change
    remove_index :promo_codes, :code

    add_index :promo_codes, :code, unique: true
  end
end
