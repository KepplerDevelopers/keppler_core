# This migration comes from keppler_capsules (originally 20180802184329)
class CreateKepplerCapsulesCapsuleFields < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_capsules_capsule_fields do |t|
      t.string :name_field
      t.string :format_field
      t.integer :capsule_id

      t.timestamps
    end
  end
end
