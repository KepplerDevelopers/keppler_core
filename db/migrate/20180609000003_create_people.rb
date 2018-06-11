class CreatePeople < ActiveRecord::Migration[5.2]
  def change
    create_table :people do |t|
      t.string :name
      t.text :bio
      t.string :photo
      t.string :email
      t.string :phone
      t.integer :age
      t.float :weight
      t.date :birth
      t.time :hour
      t.references :user, foreign_key: true
      t.boolean :public
      t.datetime :arrived
      t.decimal :decimal
      t.integer :position
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :people, :deleted_at
  end
end
