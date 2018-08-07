# This migration comes from keppler_capsules (originally 20180807200614)
class RemoveOywjhdffgeNameFromKepplerCapsulesStudents < ActiveRecord::Migration[5.2]
  def change
    remove_column :keppler_capsules_students, :name
  end
end
