# Customize Model
class Customize < ActiveRecord::Base
  include ActivityHistory
  include CloneRecord
  mount_uploader :file, TemplateUploader

  # Fields for the search form in the navbar
  def self.search_field
    :file_cont
  end

  def name
    if self.file?
      "#{self.file.to_s.split("/").last.split(".").first.capitalize} Template"
    else
      "Keppler Default"
    end
  end
end
