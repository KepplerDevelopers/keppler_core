#Generado por keppler
require 'elasticsearch/model'
<% module_namespacing do -%>
class <%= class_name %> < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  def self.searching(query)
    if query
      self.search(self.query query).records.order(id: :desc)
    else
      self.order(id: :desc)
    end
  end

  def self.query(query)
    { query: { multi_match:  { query: query, fields: [] , operator: :and }  }, sort: { id: "desc" }, size: self.count }
  end

  #armar indexado de elasticserch
  def as_indexed_json(options={})
    {
      id: self.id.to_s,
      <%- attributes.each do |attribute| -%>
      <%= attribute.name%>:  self.<%= attribute.name%>.to_s,
      <%- end -%>
    }.as_json
  end

end
#<%= class_name %>.import
<% end -%>