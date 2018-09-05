class CreateKepplerFrontendFunctions < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_frontend_functions do |t|
      t.string :name
      t.text :description
      t.integer :position
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :keppler_frontend_functions, :deleted_at
  end
end
