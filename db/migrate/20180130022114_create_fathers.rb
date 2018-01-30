class CreateFathers < ActiveRecord::Migration
  def change
    create_table :fathers do |t|
      t.string :avatar
      t.string :name
      t.string :email
      t.string :icon
      t.string :logo

      t.integer :position
      t.timestamps null: false
    end
  end
end
