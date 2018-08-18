# frozen_string_literal: true

module Ckeditor
  # Ckeditor::Picture model
  class Picture < Ckeditor::Asset
    mount_uploader :data, CkeditorPictureUploader, mount_on: :data_file_name

    def url_content
      url(:content)
    end
  end
end
