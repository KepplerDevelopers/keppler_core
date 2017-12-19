class AddColorToBrandingTable < ActiveRecord::Migration
  def change
    add_column :brandings, :headline_color, :string
  end
end
