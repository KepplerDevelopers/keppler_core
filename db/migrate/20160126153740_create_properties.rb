class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.string :name
      t.string :tracking_id
      t.string :url
      t.integer :google_analytic_id

      t.timestamps null: false
    end
  end
end
