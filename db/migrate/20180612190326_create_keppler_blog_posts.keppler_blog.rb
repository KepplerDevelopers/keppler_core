# This migration comes from keppler_blog (originally 20150714183241)
class CreateKepplerBlogPosts < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_blog_posts do |t|
      t.boolean :comments_open
      t.boolean :public
      t.boolean :shared_enabled

      t.string :image
      t.string :permalink
      t.string :title

      t.text :body

      t.references :user, foreign_key: true
      # t.references :category, foreign_key: true
      # t.references :subcategory, foreign_key: true

      t.integer :position
      t.datetime :deleted_at

      t.timestamps null: false
    end
    add_index :keppler_blog_posts, :deleted_at
  end
end
