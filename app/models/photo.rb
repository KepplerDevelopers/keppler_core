# Photo Model
class Photo < ActiveRecord::Base
  include ActivityHistory
  include CloneRecord
  belongs_to :gallery
  require 'csv'
  mount_uploader :photo, AttachmentUploader
  acts_as_list
  # Fields for the search form in the navbar
  def self.search_field
    :photo_or_gallery_id_cont
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      begin
        Photo.create! row.to_hash
      rescue => err
      end
    end
  end
end
