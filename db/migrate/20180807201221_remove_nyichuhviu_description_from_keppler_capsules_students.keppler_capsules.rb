# This migration comes from keppler_capsules (originally 20180807201219)
class RemoveNyichuhviuDescriptionFromKepplerCapsulesStudents < ActiveRecord::Migration[5.2]
  def change
    remove_column :keppler_capsules_students, :description
  end
end
