class AddLodthoyzjaNameToKepplerCapsulesStudents < ActiveRecord::Migration[5.2]
  def change
    add_column :keppler_capsules_students, :name, :string
  end
end
