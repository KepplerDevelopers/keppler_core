# frozen_string_literal: true

module <%= ROCKET_CLASS_NAME %>
  # <%= MODULE_CLASS_NAME %> Model
  class <%= MODULE_CLASS_NAME %> < ApplicationRecord
    include ActivityHistory
    include CloneRecord
    include Uploadable
    include Downloadable
    include Sortable
    include Searchable
    <%- ATTRIBUTES.each do |attribute| -%>
      <%- if SINGULAR_ATTACHMENTS.include?(attribute.first) -%>
    mount_uploader :<%=attribute.first%>, AttachmentUploader
      <%- elsif PLURAL_ATTACHMENTS.include?(attribute.first) -%>
    mount_uploaders :<%=attribute.first%>, AttachmentUploader
      <%- end -%>
      <%- if attribute.last.eql?('references') -%>
    belongs_to :<%= attribute.first %>
      <%- end -%>
    <%- end -%>
    acts_as_list
    acts_as_paranoid

    def self.index_attributes
      %i[<%= SEARCHABLE_ATTRIBUTES -%>]
    end
  end
end
