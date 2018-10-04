class CreateKepplerStarklordElliots < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_starklord_elliots do |t|
      t.references :user, foreign_key: true
      t.string :avatar
      t.jsonb :photos
      t.string :name
      t.date :birthdate
      t.integer :position
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
