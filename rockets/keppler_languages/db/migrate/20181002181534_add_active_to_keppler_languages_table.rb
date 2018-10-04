class AddActiveToKepplerLanguagesTable < ActiveRecord::Migration[5.2]
  def change
    add_column :keppler_languages_languages, :active, :boolean
  end
end
