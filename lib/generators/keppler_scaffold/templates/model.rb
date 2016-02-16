require 'elasticsearch/model'

# <%= class_name %> Model
<% module_namespacing do -%>
class <%= class_name %> < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  include PublicActivity::Model
  tracked owner: ->(controller, _) { controller && controller.current_user }

  after_commit on: [:update] do
    __elasticsearch__.index_document
  end

  def self.searching(query)
    if query
      search(query(query)).records.order(id: :desc)
    else
      order(id: :desc)
    end
  end

  def self.query(query)
    { query: { multi_match:  {
      query: query,
      fields: [], operator: :and }
    }, sort: { id: 'desc' }, size: count }
  end

  # Build index elasticsearch
  def as_indexed_json(_options={})
    {
      id: id.to_s,
      <%- attributes.each do |attribute| -%>
      <%= attribute.name%>: <%= attribute.name%>.to_s,
      <%- end -%>
    }.as_json
  end
end
<% end -%>
