require 'elasticsearch/model'

# GoogleAnayticsTrack Model
class GoogleAnalyticsTrack < ActiveRecord::Base
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
    { query: { multi_match: {
      query: query, fields: [:name, :tracking_id, :url], operator: :and }
    }, sort: { id: 'desc' }, size: count }
  end

  def self.get_tracking_id(request)
    find_by_url(request.url)
  end

  # Build index elasticsearch
  def as_indexed_json
    {
      id: id.to_s,
      name:  name,
      tracking_id:  tracking_id,
      url:  url
    }.as_json
  end
end
