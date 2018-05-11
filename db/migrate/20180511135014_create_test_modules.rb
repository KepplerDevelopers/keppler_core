class CreateTestModules < ActiveRecord::Migration
  def change
    create_table :test_modules do |t|
      t.string :photo
      t.string :name
      t.string :phone
      t.boolean :public
      t.integer :age
      t.float :weight

      t.integer :position
      t.timestamps null: false
    end
  end
end
