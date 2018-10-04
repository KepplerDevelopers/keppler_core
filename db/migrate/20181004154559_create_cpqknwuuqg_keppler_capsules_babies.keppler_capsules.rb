# This migration comes from keppler_capsules (originally 20181004154552)
class CreateCpqknwuuqgKepplerCapsulesBabies < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_capsules_babies do |t|
      t.string :name
      t.integer :position
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :keppler_capsules_babies, :deleted_at
  end
end
