# This migration comes from keppler_frontend (originally 20180806203329)
class CreateKepplerFrontendPartials < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_frontend_partials do |t|
      t.string :name
      t.integer :position
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :keppler_frontend_partials, :deleted_at
  end
end
