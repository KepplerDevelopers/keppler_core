class CreateFathers < ActiveRecord::Migration
  def change
    create_table :fathers do |t|
      t.string :name
      t.string :avatar
      t.string :email

      t.integer :position
      t.timestamps null: false
    end
  end
end
