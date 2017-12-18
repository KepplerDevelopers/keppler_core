# Branding Model
class Branding < ActiveRecord::Base
  include ActivityHistory
  include CloneRecord

  mount_uploader :banner, AttachmentUploader
  mount_uploader :headline_image, AttachmentUploader

  # Fields for the search form in the navbar
  def self.search_field
    :banner_or_headline_text_or_style_type_or_title_or_description_cont
  end
end
