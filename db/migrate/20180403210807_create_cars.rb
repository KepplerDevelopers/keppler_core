class CreateCars < ActiveRecord::Migration
  def change
    create_table :cars do |t|
      t.string :name
      t.string :color
      t.boolean :selled
      t.string :photo

      t.integer :position
      t.timestamps null: false
    end
  end
end
