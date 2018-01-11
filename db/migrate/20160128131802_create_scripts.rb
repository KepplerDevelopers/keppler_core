class CreateScripts < ActiveRecord::Migration
  def change
    create_table :scripts do |t|
      t.string :name
      t.text :script
      t.string :url

      t.timestamps null: false
    end
  end
end
