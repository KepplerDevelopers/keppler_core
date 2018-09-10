# This migration comes from keppler_frontend (originally 20180827154249)
class CreateKepplerFrontendViewCallbacks < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_frontend_view_callbacks do |t|
      t.string :name
      t.string :function_type
      t.integer :view_id
      
      t.timestamps
    end
  end
end
