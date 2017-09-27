class CreateBanners < ActiveRecord::Migration
  def change
    create_table :banners do |t|
      t.string :cover
      t.references :category, index: true

      t.timestamps null: false
    end
    add_foreign_key :banners, :categories
  end
end
