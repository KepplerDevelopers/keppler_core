class CreateApparences < ActiveRecord::Migration
  def change
    create_table :apparences do |t|
      t.string :image_background
      t.string :theme_name
      t.string :setting_id

      t.timestamps null: false
    end
  end
end
