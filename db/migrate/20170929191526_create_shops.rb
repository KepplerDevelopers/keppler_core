class CreateShops < ActiveRecord::Migration
  def change
    create_table :shops do |t|
      t.string :image
      t.string :name
      t.references :category, index: true

      t.timestamps null: false
    end
    add_foreign_key :shops, :categories
  end
end
