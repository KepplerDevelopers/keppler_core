# This migration comes from keppler_capsules (originally 20180807202410)
class AddLodthoyzjaNameToKepplerCapsulesStudents < ActiveRecord::Migration[5.2]
  def change
    add_column :keppler_capsules_students, :name, :string
  end
end
