class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :name
      t.string :description
      t.string :phone
      t.string :mobile
      t.string :email
      t.string :logo
      t.string :favicon

      t.timestamps null: false
    end
  end
end
