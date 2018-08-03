class CreateKepplerCapsulesCatalogs < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_capsules_catalogs do |t|
      t.string :photo
      t.string :name
      t.text :description
      t.integer :position
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :keppler_capsules_catalogs, :deleted_at
  end
end
