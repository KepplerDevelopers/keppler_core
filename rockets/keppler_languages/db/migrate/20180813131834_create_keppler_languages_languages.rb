class CreateKepplerLanguagesLanguages < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_languages_languages do |t|
      t.string :name
      t.boolean :active
      t.integer :position
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :keppler_languages_languages, :deleted_at
  end
end
