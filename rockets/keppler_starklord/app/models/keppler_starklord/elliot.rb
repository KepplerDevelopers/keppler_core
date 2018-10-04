# frozen_string_literal: true

module KepplerStarklord
  # Elliot Model
  class Elliot < ApplicationRecord
    include ActivityHistory
    include CloneRecord
    include Uploadable
    include Downloadable
    include Sortable
    belongs_to :user
    mount_uploader :avatar, AttachmentUploader
    mount_uploaders :photos, AttachmentUploader
    acts_as_list
    acts_as_paranoid

    # Fields for the search form in the navbar
    def self.search_field
      fields = %i[name]
      build_query(fields, :or, :cont)
    end

    # Funcion para armar el query de ransack
    def self.build_query(fields, operator, conf)
      query = fields.join("_#{operator}_")
      query << "_#{conf}"
      query.to_sym
    end
  end
end
