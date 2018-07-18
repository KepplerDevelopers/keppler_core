class CreateMetaTags < ActiveRecord::Migration[5.1]
  def change
    create_table :meta_tags do |t|
      t.string :title
      t.text :description
      t.text :meta_tags
      t.string :url
      t.integer :position

      t.timestamps null: false
    end
  end
end
