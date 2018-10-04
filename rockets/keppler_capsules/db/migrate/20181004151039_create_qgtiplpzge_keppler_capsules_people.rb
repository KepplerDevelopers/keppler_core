class CreateQgtiplpzgeKepplerCapsulesPeople < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_capsules_people do |t|
      t.string :name
      t.integer :age
      t.integer :position
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :keppler_capsules_people, :deleted_at
  end
end
