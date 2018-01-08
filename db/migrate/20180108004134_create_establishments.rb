class CreateEstablishments < ActiveRecord::Migration
  def change
    create_table :establishments do |t|
      t.string :name
      t.string :city
      t.string :email

      t.timestamps null: false
    end
  end
end
