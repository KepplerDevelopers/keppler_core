# This migration comes from keppler_to_do (originally 20181011154957)
class CreateKepplerToDoTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_to_do_tasks do |t|
      t.string :name
      t.integer :position
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
