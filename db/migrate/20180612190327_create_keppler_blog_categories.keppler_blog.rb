# This migration comes from keppler_blog (originally 20150714192018)
class CreateKepplerBlogCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_blog_categories do |t|
      t.string :name
      t.string :permalink

      t.timestamps null: false
    end
  end
end
