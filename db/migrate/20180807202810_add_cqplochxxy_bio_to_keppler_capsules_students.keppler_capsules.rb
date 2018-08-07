# This migration comes from keppler_capsules (originally 20180807202808)
class AddCqplochxxyBioToKepplerCapsulesStudents < ActiveRecord::Migration[5.2]
  def change
    add_column :keppler_capsules_students, :bio, :text
  end
end
