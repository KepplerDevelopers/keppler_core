# Proyect Model
class Proyect < ActiveRecord::Base
  include ActivityHistory
  include CloneRecord

  mount_uploader :banner, AttachmentUploader
  mount_uploader :brand, AttachmentUploader
  # Fields for the search form in the navbar
  def self.search_field
    :banner_or_headline_or_service_type_or_description_or_name_or_share_cont
  end
end
