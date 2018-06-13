# This migration comes from keppler_blog (originally 20150715002011)
class CreateKepplerBlogSubcategories < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_blog_subcategories do |t|
      t.string :name
      # t.references :category, foreign_key: true

      t.timestamps null: false
    end
  end
end
