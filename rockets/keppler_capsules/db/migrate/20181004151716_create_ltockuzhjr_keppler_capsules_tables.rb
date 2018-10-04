class CreateLtockuzhjrKepplerCapsulesTables < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_capsules_tables do |t|
      t.string :row
      t.string :column
      t.integer :position
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :keppler_capsules_tables, :deleted_at
  end
end
