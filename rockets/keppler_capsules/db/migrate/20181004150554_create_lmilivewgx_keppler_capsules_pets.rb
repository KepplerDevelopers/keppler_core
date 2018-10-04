class CreateLmilivewgxKepplerCapsulesPets < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_capsules_pets do |t|
      t.string :name
      t.integer :position
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :keppler_capsules_pets, :deleted_at
  end
end
