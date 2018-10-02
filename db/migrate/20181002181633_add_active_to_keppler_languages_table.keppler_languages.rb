# This migration comes from keppler_languages (originally 20181002181534)
class AddActiveToKepplerLanguagesTable < ActiveRecord::Migration[5.2]
  def change
    add_column :keppler_languages_languages, :active, :boolean
  end
end
