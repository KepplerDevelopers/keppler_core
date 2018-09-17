class CreateKepplerContactUsMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :keppler_contact_us_messages do |t|
      t.string :name
      t.string :from_email
      t.jsonb :to_emails
      t.string :subject
      t.text :content
      t.boolean :read
      t.boolean :favorite
      t.integer :position
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :keppler_contact_us_messages, :deleted_at
  end
end
