class CreatePeople < ActiveRecord::Migration[5.2]
  def change
    create_table :people do |t|
      t.string :avatar
      t.string :name
      t.text :bio
      t.date :birthdate
      t.time :hour
      t.boolean :public
      t.references :user, foreign_key: true
      t.integer :position
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :people, :deleted_at
  end
end
