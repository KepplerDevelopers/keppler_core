class CreateDelqxoqlqsKepplerCapsulesPedros < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_capsules_pedros do |t|
      t.string :name
      t.text :bio
      t.integer :age
      t.integer :position
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :keppler_capsules_pedros, :deleted_at
  end
end
