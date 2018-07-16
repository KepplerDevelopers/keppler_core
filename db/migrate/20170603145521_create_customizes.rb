class CreateCustomizes < ActiveRecord::Migration[5.1]
  def change
    create_table :customizes do |t|
      t.string :file
      t.boolean :installed

      t.timestamps null: false
    end
  end
end
