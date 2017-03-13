class AddNamePhoneToUsers < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |t|
      t.string :phone
      t.string :name
      t.string :oauth_provider
      t.string :oauth_uid
    end
  end
end
