class CreateScaffolds < ActiveRecord::Migration[5.1]
  def change
    create_table :scaffolds do |t|
      t.string :name
      t.string :fields

      t.timestamps null: false
    end
  end
end
