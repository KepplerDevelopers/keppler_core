# This migration comes from keppler_capsules (originally 20181004154647)
class DropEvokzqvlgxKepplerCapsulesBabies < ActiveRecord::Migration[5.2]
  def change
    drop_table :keppler_capsules_babies
  end
end
