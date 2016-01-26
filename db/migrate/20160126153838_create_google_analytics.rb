class CreateGoogleAnalytics < ActiveRecord::Migration
  def change
    create_table :google_analytics do |t|
      t.string :ga_account_id
      t.integer :setting_id

      t.timestamps null: false
    end
  end
end
