# GoogleAnayticsTrack Model
class GoogleAnalyticsTrack < ActiveRecord::Base
  include ElasticSearchable
  include ActivityHistory

  def self.searching(query)
    if query
      search(query(query)).records.order(id: :desc)
    else
      order(id: :desc)
    end
  end

  def self.query(query)
    { query: { multi_match: {
      query: query,
      fields: [:name, :tracking_id, :url],
      operator: :and,
      lenient: true }
    }, sort: { id: 'desc' }, size: count }
  end

  def self.get_tracking_id(request)
    find_by_url(request.url)
  end

  # Build index elasticsearch
  def as_indexed_json(_options = {})
    as_json(
      only: [:id, :name, :tracking_id, :url]
    )
  end
end
