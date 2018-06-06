# frozen_string_literal: true

# <%= class_name %> Model
<% module_namespacing do -%>
class <%= class_name %> < ApplicationRecord
  include ActivityHistory
  include CloneRecord
  include Uploadable
  include Downloadable
  include Sortable
  <%- attributes.each do |attribute| -%>
    <%- if @attachments.include?(attribute.name) -%>
  mount_uploader :<%=attribute.name%>, AttachmentUploader
    <%- end -%>
    <%- if attribute.reference? -%>
  belongs_to :<%= attribute.name %>
    <%- end -%>
  <%- end -%>
  acts_as_list
  acts_as_paranoid

  # Fields for the search form in the navbar
  def self.search_field
    fields = %i[<%= attributes_names.map { |name| name }.join(' ') %>]
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
