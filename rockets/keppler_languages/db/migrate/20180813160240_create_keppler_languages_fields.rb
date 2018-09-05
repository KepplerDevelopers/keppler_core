class CreateKepplerLanguagesFields < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_languages_fields do |t|
      t.string :key
      t.text :value
      t.integer :language_id
      t.integer :position
      t.datetime :deleted_at
    end
    add_index :keppler_languages_fields, :deleted_at
  end
end
