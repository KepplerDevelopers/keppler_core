# This migration comes from keppler_capsules (originally 20180802184153)
class CreateKepplerCapsulesCapsules < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_capsules_capsules do |t|
      t.string :name
      t.integer :position
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :keppler_capsules_capsules, :deleted_at
  end
end
