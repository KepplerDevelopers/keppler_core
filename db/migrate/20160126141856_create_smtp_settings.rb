class CreateSmtpSettings < ActiveRecord::Migration[5.1]
  def change
    create_table :smtp_settings do |t|
      t.string :address
      t.string :port
      t.string :domain_name
      t.string :email
      t.string :password
      t.integer :setting_id

      t.timestamps null: false
    end
    add_index :smtp_settings, :setting_id
  end
end
