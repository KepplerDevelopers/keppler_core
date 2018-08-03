class CreateKepplerCapsulesCpslPeople < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_capsules_cpsl_people do |t|
      t.string :name
      t.integer :phone
      t.integer :position
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :keppler_capsules_cpsl_people, :deleted_at
  end
end
