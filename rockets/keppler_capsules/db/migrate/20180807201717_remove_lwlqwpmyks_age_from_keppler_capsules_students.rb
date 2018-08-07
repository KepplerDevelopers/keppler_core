class RemoveLwlqwpmyksAgeFromKepplerCapsulesStudents < ActiveRecord::Migration[5.2]
  def change
    remove_column :keppler_capsules_students, :age
  end
end
