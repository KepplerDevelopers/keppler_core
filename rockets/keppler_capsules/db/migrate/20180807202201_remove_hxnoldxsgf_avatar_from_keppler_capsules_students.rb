class RemoveHxnoldxsgfAvatarFromKepplerCapsulesStudents < ActiveRecord::Migration[5.2]
  def change
    remove_column :keppler_capsules_students, :avatar
  end
end
