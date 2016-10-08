class CreateTeamMembers < ActiveRecord::Migration[5.0]
  def change
    create_table :team_members do |t|
      t.string :name
      t.string :role
      t.string :image
      t.string :motto
      t.integer :position

      t.timestamps null: false
    end
  end
end
