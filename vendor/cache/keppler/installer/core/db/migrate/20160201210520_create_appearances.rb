class CreateAppearances < ActiveRecord::Migration[5.1]
  def change
    create_table :appearances do |t|
      t.string :image_background
      t.string :theme_name
      t.string :setting_id

      t.timestamps null: false
    end
  end
end
