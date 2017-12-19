class CreateTermsAndConditions < ActiveRecord::Migration
  def change
    create_table :terms_and_conditions do |t|
      t.text :content

      t.timestamps null: false
    end
  end
end
