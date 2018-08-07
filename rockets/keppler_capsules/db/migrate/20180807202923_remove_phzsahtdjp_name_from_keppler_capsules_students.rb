class RemovePhzsahtdjpNameFromKepplerCapsulesStudents < ActiveRecord::Migration[5.2]
  def change
    remove_column :keppler_capsules_students, :name
  end
end
