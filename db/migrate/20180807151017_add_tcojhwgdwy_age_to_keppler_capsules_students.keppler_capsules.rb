# This migration comes from keppler_capsules (originally 20180807151015)
class AddTcojhwgdwyAgeToKepplerCapsulesStudents < ActiveRecord::Migration[5.2]
  def change
    add_column :keppler_capsules_students, :age, :integer
  end
end
