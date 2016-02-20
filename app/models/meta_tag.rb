# MetaTag Model
class MetaTag < ActiveRecord::Base
  include ElasticSearchable
  include ActivityHistory

  def self.query(query)
    { query: { multi_match: {
      query: query,
      fields: [:title, :description, :url],
      operator: :and,
      lenient: true }
    }, sort: { id: 'desc' }, size: count }
  end

  def self.get_by_url(url)
    find_by_url(url)
  end

  # Build index elasticsearch
  def as_indexed_json(_options = {})
    as_json(
      only: [:id, :title, :description, :url]
    )
  end
end
