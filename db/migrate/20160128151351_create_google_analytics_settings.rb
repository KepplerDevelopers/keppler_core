class CreateGoogleAnalyticsSettings < ActiveRecord::Migration[5.1]
  def change
    create_table :google_analytics_settings do |t|
      t.string :ga_account_id
      t.string :ga_tracking_id
      t.boolean :ga_status
      t.integer :setting_id

      t.timestamps null: false
    end
  end
end
