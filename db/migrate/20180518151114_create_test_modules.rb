class CreateTestModules < ActiveRecord::Migration[5.2]
  def change
    create_table :test_modules do |t|
      t.string :name
      t.string :image
      t.integer :position
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :test_modules, :deleted_at
  end
end
