#Generado por keppler
require 'elasticsearch/model'
class Setting < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }

  has_one :smtp_setting
  has_one :google_analytic
  accepts_nested_attributes_for :smtp_setting, :google_analytic
  
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
    { query: { multi_match:  { query: query, fields: [] , operator: :and }  }, sort: { id: "desc" }, size: self.count }
  end

  #armar indexado de elasticserch
  def as_indexed_json(options={})
    {
      id: self.id.to_s,
      name:  self.name.to_s,
      description:  self.description.to_s,
      logo:  self.logo.to_s,
      favicon:  self.favicon.to_s,
    }.as_json
  end

end
#Setting.import
