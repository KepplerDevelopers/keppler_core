class CreateBriefings < ActiveRecord::Migration
  def change
    create_table :briefings do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :company
      t.string :services_type
      t.string :other
      t.text :about

      t.timestamps null: false
    end
  end
end
