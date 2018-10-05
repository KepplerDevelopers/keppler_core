# This migration comes from keppler_languages (originally 20180813131834)
class CreateKepplerLanguagesLanguages < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_languages_languages do |t|
      t.string :name
      t.boolean :active
      t.string :field_ids
      t.integer :position
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
