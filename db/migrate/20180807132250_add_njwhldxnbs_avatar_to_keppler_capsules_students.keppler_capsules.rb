# This migration comes from keppler_capsules (originally 20180807132246)
class AddNjwhldxnbsAvatarToKepplerCapsulesStudents < ActiveRecord::Migration[5.2]
  def change
    add_column :keppler_capsules_students, :avatar, :string
  end
end
