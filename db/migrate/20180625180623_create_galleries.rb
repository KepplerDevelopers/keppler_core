class CreateGalleries < ActiveRecord::Migration[5.2]
  def change
    create_table :galleries do |t|
      t.string :avatar
      t.jsonb :images
      t.string :video
      t.string :audio
      t.string :pdf
      t.string :txt
      t.jsonb :files
      t.integer :position
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :galleries, :deleted_at
  end
end
