class CreatePermissions < ActiveRecord::Migration[5.2]
  def change
    create_table :permissions do |t|
      t.jsonb :modules
      t.references :role, foreign_key: true

      t.string :deleted_at
      t.timestamps
    end
  end
end
