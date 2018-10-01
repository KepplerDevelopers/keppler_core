# frozen_string_literal: true

module <%= ROCKET_CLASS_NAME %>
  # <%= MODULE_CLASS_NAME %> Model
  <% module_namespacing do -%>
  class <%= MODULE_CLASS_NAME %> < ApplicationRecord
    include ActivityHistory
    include CloneRecord
    include Uploadable
    include Downloadable
    include Sortable
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

    # Fields for the search form in the navbar
    def self.search_field
      fields = %i[<%= SEARCHABLE_ATTRIBUTES %>]
      build_query(fields, :or, :cont)
    end

    # Funcion para armar el query de ransack
    def self.build_query(fields, operator, conf)
      query = fields.join("_#{operator}_")
      query << "_#{conf}"
      query.to_sym
    end
  end
  <% end -%>
end