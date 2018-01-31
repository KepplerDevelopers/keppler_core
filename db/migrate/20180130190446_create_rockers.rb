class CreateRockers < ActiveRecord::Migration
  def change
    create_table :rockers do |t|
      t.string :avatar
      t.string :name

      t.integer :position
      t.timestamps null: false
    end
  end
end
