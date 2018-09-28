# This migration comes from keppler_capsules (originally 20180925184804)
class CreateOsginvwbqgKepplerCapsulesPosts < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_capsules_posts do |t|
      t.string :title
      t.string :photo
      t.text :content
      t.integer :position
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :keppler_capsules_posts, :deleted_at
  end
end
