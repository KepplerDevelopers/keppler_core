class CreateScripts < ActiveRecord::Migration[5.1]
  def change
    create_table :scripts do |t|
      t.string :name
      t.text :script
      t.string :url

      t.integer :position
      t.timestamps null: false
    end
  end
end
