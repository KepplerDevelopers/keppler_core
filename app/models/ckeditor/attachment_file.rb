# frozen_string_literal: true

module Ckeditor
  # Ckeditor::Picture model
  class AttachmentFile < Ckeditor::Asset
    m = CkeditorAttachmentFileUploader
    mount_uploader :data, m, mount_on: :data_file_name

    def url_thumb
      @url_thumb ||= Ckeditor::Utils.filethumb(filename)
    end
  end
end
