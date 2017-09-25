# Developer Model
class Developer < ActiveRecord::Base
  include ActivityHistory
  include CloneRecord
  mount_uploader :avatar, AttachmentUploader

  # Fields for the search form in the navbar
  def self.search_field
    :avatar_or_name_cont
  end
end
