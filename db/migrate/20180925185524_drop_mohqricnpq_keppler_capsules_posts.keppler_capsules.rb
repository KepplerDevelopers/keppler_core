# This migration comes from keppler_capsules (originally 20180925185520)
class DropMohqricnpqKepplerCapsulesPosts < ActiveRecord::Migration[5.2]
  def change
    drop_table :keppler_capsules_posts
  end
end
