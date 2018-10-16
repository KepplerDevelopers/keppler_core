# frozen_string_literal: true

module KepplerWorld
  # Planet Model
  class Planet < ApplicationRecord
    include ActivityHistory
    include CloneRecord
    include Uploadable
    include Downloadable
    include Sortable
    include Searchable
    mount_uploaders :images, AttachmentUploader
    mount_uploader :avatar, AttachmentUploader
    acts_as_list
    acts_as_paranoid

    def self.index_attributes
      %i[avatar name images money age]
    end
  end
end
