# Module ElasticSearchable
module ElasticSearchable
  extend ActiveSupport::Concern

  included do
    require 'elasticsearch/model'
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    after_commit on: [:update] do
      __elasticsearch__.index_document
    end
  end

  # ClassMethods
  module ClassMethods
    def searching(query)
      if query
        search(query(query)).records.order(id: :desc)
      else
        order(id: :desc)
      end
    end
  end
end
