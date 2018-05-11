# TestModule Model
class TestModule < ActiveRecord::Base
  include ActivityHistory
  include CloneRecord
  require 'csv'
  mount_uploader :photo, AttachmentUploader
  acts_as_list
  # Fields for the search form in the navbar
  def self.search_field
    :photo_or_name_or_phone_or_public_or_age_or_weight_cont
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      begin
        TestModule.create! row.to_hash
      rescue => err
      end
    end
  end
end
