# GoogleAdword Model
class GoogleAdword < ActiveRecord::Base
  include ElasticSearchable
  include ActivityHistory

  def self.query(query)
    { query: { multi_match: {
      query: query,
      fields: [:url, :campaign_name, :description],
      operator: :and,
      lenient: true
    } }, sort: { id: 'desc' }, size: count }
  end

  def self.get_by_url(url)
    find_by_url(url)
  end

  # Build index eslasticsearch
  def as_indexed_json(_options = {})
    as_json(
      only: [:url, :campaign_name, :description]
    )
  end
end
