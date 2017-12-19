# This migration comes from keppler_blog (originally 20150715002011)
class CreateKepplerBlogSubcategories < ActiveRecord::Migration
  def change
    create_table :keppler_blog_subcategories do |t|
      t.string :name
      t.string :permalink
      t.integer :category_id

      t.timestamps null: false
    end
  end
end
