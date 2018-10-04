# This migration comes from keppler_capsules (originally 20181004152655)
class CreateKrmyxgtgypKepplerCapsulesUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_capsules_users do |t|
      t.string :name
      t.text :bio
      t.integer :position
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :keppler_capsules_users, :deleted_at
  end
end
