class CreateKepplerFrontendThemes < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_frontend_themes do |t|
      t.string :name
      t.boolean :active
      t.integer :position
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :keppler_frontend_themes, :deleted_at
  end
end
