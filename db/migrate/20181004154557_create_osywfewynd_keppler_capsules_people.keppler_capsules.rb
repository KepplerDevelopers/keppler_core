# This migration comes from keppler_capsules (originally 20181004153702)
class CreateOsywfewyndKepplerCapsulesPeople < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_capsules_people do |t|
      t.string :asdasd
      t.string :asdads
      t.string :sdasd
      t.integer :position
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :keppler_capsules_people, :deleted_at
  end
end
