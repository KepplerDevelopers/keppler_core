# This migration comes from keppler_capsules (originally 20181008134907)
class DropLakuyanouwKepplerCapsulesLuizs < ActiveRecord::Migration[5.2]
  def change
    drop_table :keppler_capsules_luizs
  end
end
