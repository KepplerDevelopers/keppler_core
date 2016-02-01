#Generado por keppler
require 'elasticsearch/model'
class GoogleAdword < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }
  
  after_commit on: [:update] do
    puts __elasticsearch__.index_document
  end
  
  def self.searching(query)
    if query
      self.search(self.query query).records.order(id: :desc)
    else
      self.order(id: :desc)
    end
  end

  def self.query(query)
    { query: { multi_match:  { query: query, fields: [:url, :campaign_name, :description] , operator: :and }  }, sort: { id: "desc" }, size: self.count }
  end

  def self.get_by_url(url)
    find_by_url(url)
  end

  #armar indexado de elasticserch
  def as_indexed_json(options={})
    {
      id: self.id.to_s,
      url:  self.url,
      campaign_name:  self.campaign_name,
      description:  self.description,
    }.as_json
  end

end
