# This migration comes from keppler_capsules (originally 20180807202201)
class RemoveHxnoldxsgfAvatarFromKepplerCapsulesStudents < ActiveRecord::Migration[5.2]
  def change
    remove_column :keppler_capsules_students, :avatar
  end
end
