# This migration comes from keppler_blog (originally 20150716214720)
# This migration comes from acts_as_taggable_on_engine (originally 4)
class AddMissingTaggableIndex < ActiveRecord::Migration[5.2]
  def self.up
    add_index :taggings, %i[taggable_id taggable_type context]
  end

  def self.down
    remove_index :taggings, %i[taggable_id taggable_type context]
  end
end
