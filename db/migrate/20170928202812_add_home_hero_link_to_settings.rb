class AddHomeHeroLinkToSettings < ActiveRecord::Migration[5.0]
  def change
    add_column :settings, :home_hero_link, :text
  end
end
