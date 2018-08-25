# This migration comes from keppler_language (originally 20180813021347)
class CreateKepplerLanguageLanguages < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_language_languages do |t|
      t.string :name
      t.integer :position
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :keppler_language_languages, :deleted_at
  end
end
