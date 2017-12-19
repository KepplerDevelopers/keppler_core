class CreateWebs < ActiveRecord::Migration
  def change
    create_table :webs do |t|
      t.string :headline
      t.string :name

      t.timestamps null: false
    end
  end
end
