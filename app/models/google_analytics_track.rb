#Generado por keppler
require 'elasticsearch/model'
class GoogleAnalyticsTrack < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }
  
  after_commit on: [:update] do
    __elasticsearch__.index_document
  end
  
  def self.searching(query)
    if query
      self.search(self.query query).records.order(id: :desc)
    else
      self.order(id: :desc)
    end
  end

  def self.query(query)
    { query: { multi_match:  { query: query, fields: [:name, :tracking_id, :url] , operator: :and }  }, sort: { id: "desc" }, size: self.count }
  end

  #armar indexado de elasticserch
  def as_indexed_json(options={})
    {
      id: self.id.to_s,
      name:  self.name,
      tracking_id:  self.tracking_id,
      url:  self.url,
    }.as_json
  end

end
