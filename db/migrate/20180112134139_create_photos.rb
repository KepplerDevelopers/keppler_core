class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :photo
      t.integer :gallery_id

      t.integer :position
      t.timestamps null: false
    end
  end
end
