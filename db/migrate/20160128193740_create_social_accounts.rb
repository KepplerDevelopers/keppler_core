class CreateSocialAccounts < ActiveRecord::Migration
  def change
    create_table :social_accounts do |t|
      t.string :facebook
      t.string :twitter
      t.string :instagram
      t.string :google_plus
      t.string :tripadvisor
      t.string :pinterest
      t.string :flickr
      t.string :behance
      t.string :dribbble
      t.string :tumblr
      t.string :github
      t.string :linkedin
      t.string :soundcloud
      t.string :youtube
      t.string :skype
      t.string :vimeo
      t.integer :setting_id

      t.timestamps null: false
    end
  end
end
