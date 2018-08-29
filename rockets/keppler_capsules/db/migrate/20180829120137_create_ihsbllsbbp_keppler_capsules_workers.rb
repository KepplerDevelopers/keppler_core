class CreateIhsbllsbbpKepplerCapsulesWorkers < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_capsules_workers do |t|
      t.string :name
      t.string :avatar
      t.integer :position
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :keppler_capsules_workers, :deleted_at
  end
end
