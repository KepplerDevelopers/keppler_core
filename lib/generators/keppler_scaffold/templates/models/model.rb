# <%= class_name %> Model
<% module_namespacing do -%>
class <%= class_name %> < ActiveRecord::Base
  include ActivityHistory
  include CloneRecord
  require 'csv'
  <%- attributes_names.each do |attribute| -%>
    <%- if @attachments.include?(attribute) -%>
  mount_uploader :<%=attribute%>, AttachmentUploader
    <%- end -%>
  <%- end -%>
  acts_as_list
  # Fields for the search form in the navbar
  def self.search_field
    <%= ":#{attributes_names.map { |name| name }.join('_or_')}_cont" %>
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      begin
        <%= class_name %>.create! row.to_hash
      rescue => err
      end
    end
  end

  def self.sorter(params)
    params.each_with_index do |id, idx|
      self.find(id).update(position: idx.to_i+1)
    end
  end
end
<% end -%>
