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
    <%- if @singular_attachments.include?(attribute.name) -%>
  mount_uploader :<%=attribute.name%>, AttachmentUploader
    <%- elsif @plural_attachments.include?(attribute.name) -%>
  mount_uploaders :<%=attribute.name%>, AttachmentUploader
    <%- end -%>
    <%- if attribute.reference? -%>
  belongs_to :<%= attribute.name %>
    <%- end -%>
  <%- end -%>
  acts_as_list
  acts_as_paranoid

  def self.index_attributes
    %i[<%= attributes.select { |k,v| @singular_attachments.exclude?(k) && @plural_attachments.exclude?(k) && %w[string text integer].include?(v) && %w[position].exclude?(k) && k.exclude?('-') }.map(&:first).join(' ') -%>]
  end
end
<% end -%>
