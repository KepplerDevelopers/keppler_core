require 'elasticsearch/model'

# GoogleAdword Model
class GoogleAdword < ActiveRecord::Base
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
      query: query, fields: [:url, :campaign_name, :description],
      operator: :and
    } }, sort: { id: 'desc' }, size: count }
  end

  def self.get_by_url(url)
    find_by_url(url)
  end

  # Build index eslasticsearch
  def as_indexed_json
    {
      id: id.to_s,
      url:  url,
      campaign_name: campaign_name,
      description: description
    }.as_json
  end
end
