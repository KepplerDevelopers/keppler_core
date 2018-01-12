# This migration comes from keppler_blog (originally 20150714183241)
class CreateKepplerBlogPosts < ActiveRecord::Migration
  def change
    create_table :keppler_blog_posts do |t|
      t.string :title
      t.text :body
      t.integer :user_id
      t.integer :category_id
      t.integer :subcategory_id
      t.string :image
      t.boolean :public
      t.boolean :comments_open
      t.boolean :shared_enabled
      t.string :permalink

      t.timestamps null: false
    end
  end
end
