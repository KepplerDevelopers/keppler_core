class CreateGoogleAdwords < ActiveRecord::Migration
  def change
    create_table :google_adwords do |t|
      t.string :url
      t.string :campaign_name
      t.text :description
      t.text :script

      t.timestamps null: false
    end
  end
end
