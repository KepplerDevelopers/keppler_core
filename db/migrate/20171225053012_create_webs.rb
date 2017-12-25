class CreateWebs < ActiveRecord::Migration
  def change
    create_table :webs do |t|
      t.string :name
      t.text :description
      t.string :date
      t.boolean :pay

      t.timestamps null: false
    end
  end
end
