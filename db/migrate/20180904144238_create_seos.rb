class CreateSeos < ActiveRecord::Migration[5.2]
  def change
    create_table :seos do |t|
      t.integer :position
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :seos, :deleted_at
  end
end
