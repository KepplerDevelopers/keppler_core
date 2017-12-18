class CreateBrandings < ActiveRecord::Migration
  def change
    create_table :brandings do |t|
      t.string :banner
      t.string :name
      t.string :headline_text
      t.string :headline_image
      t.string :headline_type
      t.string :style_type
      t.string :title
      t.text :description

      t.timestamps null: false
    end
  end
end
