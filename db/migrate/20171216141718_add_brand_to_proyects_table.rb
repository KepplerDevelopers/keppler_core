class AddBrandToProyectsTable < ActiveRecord::Migration
  def change
    add_column :proyects, :brand, :string
  end
end
