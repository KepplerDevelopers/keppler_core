# This migration comes from keppler_capsules (originally 20181004154346)
class CreateVzlzauggypKepplerCapsulesDogs < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_capsules_dogs do |t|
      t.string :name
      t.integer :position
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :keppler_capsules_dogs, :deleted_at
  end
end
