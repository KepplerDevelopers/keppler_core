class CreateCaches < ActiveRecord::Migration
  def change
    create_table :caches do |t|
      t.string :image

      t.timestamps null: false
    end
  end
end
