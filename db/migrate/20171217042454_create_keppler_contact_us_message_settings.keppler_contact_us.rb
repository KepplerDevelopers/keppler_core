# This migration comes from keppler_contact_us (originally 20161111200634)
class CreateKepplerContactUsMessageSettings < ActiveRecord::Migration
  def change
    create_table :keppler_contact_us_message_settings do |t|
      t.string :mailer_to
      t.string :mailer_from

      t.timestamps null: false
    end
  end
end
