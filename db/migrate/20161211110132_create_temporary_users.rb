class CreateTemporaryUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :temporary_users do |t|
      t.string :uuid
      t.datetime :last_active_at

      t.timestamps null: false
    end
  end
end
