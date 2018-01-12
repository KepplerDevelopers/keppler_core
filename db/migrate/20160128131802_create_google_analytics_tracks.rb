class CreateGoogleAnalyticsTracks < ActiveRecord::Migration
  def change
    create_table :google_analytics_tracks do |t|
      t.string :name
      t.string :tracking_id
      t.string :url

      t.timestamps null: false
    end
  end
end
