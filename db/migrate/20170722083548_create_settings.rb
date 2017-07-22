class CreateSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :settings do |t|
      t.string :phone
      t.string :email
      t.string :facebook
      t.string :twitter
      t.string :instagram

      t.string :home_hero_title
      t.text :home_hero_details
      t.string :home_hero_image

      t.text :team_hero_details
    end
  end
end
