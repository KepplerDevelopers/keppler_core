class AddColorToMarketingTable < ActiveRecord::Migration
  def change
    add_column :marketings, :headline_color, :string
  end
end
