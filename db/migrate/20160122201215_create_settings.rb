class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :name
      t.string :description
      t.string :logo
      t.string :favicon
      t.string :ga_account_id

      t.timestamps null: false
    end
  end
end
