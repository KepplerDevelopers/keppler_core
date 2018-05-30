class CreatePeople < ActiveRecord::Migration[5.2]
  def change
    create_table :people do |t|
      t.string :photo
      t.string :name
      t.text :description
      t.date :birth
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
