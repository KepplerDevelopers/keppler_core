# <%= class_name %> Model
<% module_namespacing do -%>
class <%= class_name %> < ActiveRecord::Base
  include ElasticSearchable
  include ActivityHistory

  def self.query(query)
    { query: { multi_match: {
      query: query,
      fields: [<%= attributes_names.map { |name| ":#{name}" }.join(', ') %>],
      operator: :and,
      lenient: true }
    }, sort: { id: 'desc' }, size: count }
  end

  # Build index elasticsearch
  def as_indexed_json(_options = {})
    as_json(
      only: [:id, <%= attributes_names.map { |name| ":#{name}" }.join(', ') %>]
    )
  end
end
<% end -%>
