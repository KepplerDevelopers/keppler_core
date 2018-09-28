class DropMohqricnpqKepplerCapsulesPosts < ActiveRecord::Migration[5.2]
  def change
    drop_table :keppler_capsules_posts
  end
end
