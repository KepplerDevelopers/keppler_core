# frozen_string_literal: true

<% module_namespacing do -%>
# <%= class_name %> Model
class <%= class_name %> < ApplicationRecord
  include ActivityHistory
  include CloneRecord
  include Uploadable
  include Downloadable
  include Sortable
  include Searchable
  <%- attributes.each do |attribute| -%>
    <%- if SINGULAR_ATTACHMENTS.include?(attribute.name) -%>
  mount_uploader :<%=attribute.name%>, AttachmentUploader
    <%- elsif PLURAL_ATTACHMENTS.include?(attribute.name) -%>
  mount_uploaders :<%=attribute.name%>, AttachmentUploader
    <%- end -%>
    <%- if attribute.reference? -%>
  belongs_to :<%= attribute.name %>
    <%- end -%>
  <%- end -%>
  acts_as_list
  acts_as_paranoid

  def self.index_attributes
    %i[<%= SEARCHABLE_ATTRIBUTES -%>]
  end
end
<% end -%>
