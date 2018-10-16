# This migration comes from keppler_world (originally 20181015211842)
class CreateKepplerWorldPlanets < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_world_planets do |t|
      t.jsonb :images
      t.string :avatar
      t.string :name
      t.text :description
      t.integer :age
      t.float :money
      t.date :fecha
      t.time :tiempo
      t.integer :position
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
