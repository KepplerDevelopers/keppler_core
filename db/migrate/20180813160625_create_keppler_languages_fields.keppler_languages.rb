# This migration comes from keppler_languages (originally 20180813160240)
class CreateKepplerLanguagesFields < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_languages_fields do |t|
      t.string :key
      t.text :value
      t.integer :language_id
      t.integer :position
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
