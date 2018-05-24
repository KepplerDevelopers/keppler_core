class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :image
      t.string :name
      t.text :body
      t.integer :position
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :posts, :deleted_at
  end
end
