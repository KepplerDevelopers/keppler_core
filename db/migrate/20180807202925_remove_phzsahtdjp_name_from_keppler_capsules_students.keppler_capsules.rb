# This migration comes from keppler_capsules (originally 20180807202923)
class RemovePhzsahtdjpNameFromKepplerCapsulesStudents < ActiveRecord::Migration[5.2]
  def change
    remove_column :keppler_capsules_students, :name
  end
end
