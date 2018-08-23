class CreateKepplerCapsulesCapsuleValidations < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_capsules_capsule_validations do |t|
      t.integer :capsule_id
      t.string :field
      t.string :validation
      t.string :name

      t.timestamps
    end
  end
end
