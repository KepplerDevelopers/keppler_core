# <%= class_name %> Model
<% module_namespacing do -%>
class <%= class_name %> < ActiveRecord::Base
  include ActivityHistory
  include CloneRecord
  <%- attributes_names.each do |attribute| -%>
    <%- if @attachments.include?(attribute) -%>
  mount_uploader :<%=attribute%>, AttachmentUploader
    <%- end -%>
  <%- end -%>

  # Fields for the search form in the navbar
  def self.search_field
    <%= ":#{attributes_names.map { |name| name }.join('_or_')}_cont" %>
  end
end
<% end -%>
