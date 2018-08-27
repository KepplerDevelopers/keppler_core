class CreateKepplerCapsulesCapsuleAssociations < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_capsules_capsule_associations do |t|
      t.string :association_type
      t.string :capsule_name
      t.boolean :dependention_destroy

      t.timestamps
    end
  end
end
