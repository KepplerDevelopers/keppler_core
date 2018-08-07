class AddCqplochxxyBioToKepplerCapsulesStudents < ActiveRecord::Migration[5.2]
  def change
    add_column :keppler_capsules_students, :bio, :text
  end
end
