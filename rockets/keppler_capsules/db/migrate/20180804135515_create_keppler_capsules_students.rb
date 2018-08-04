class CreateKepplerCapsulesStudents < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_capsules_students do |t|
      t.string :name
      t.text :bio
      t.integer :position
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :keppler_capsules_students, :deleted_at
  end
end
