# This migration comes from keppler_frontend (originally 20180830153029)
class CreateKepplerFrontendParameters < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_frontend_parameters do |t|
      t.string :name
      t.integer :position
      t.datetime :deleted_at
      t.string :function_id
      t.timestamps
    end
    add_index :keppler_frontend_parameters, :deleted_at
  end
end
