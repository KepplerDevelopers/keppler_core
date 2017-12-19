class CreateProyects < ActiveRecord::Migration
  def change
    create_table :proyects do |t|
      t.string :banner
      t.string :headline
      t.string :service_type
      t.text :description
      t.string :name
      t.boolean :share

      t.timestamps null: false
    end
  end
end
