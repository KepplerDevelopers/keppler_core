module KepplerBlog
  class Category < ActiveRecord::Base
    include ActivityHistory
    before_save :create_permalink
    has_many :posts, dependent: :destroy
    has_many :subcategories
    accepts_nested_attributes_for :subcategories, :reject_if => :all_blank, :allow_destroy => true

    def self.query(query)
      { query: { multi_match:  { query: query, fields: [:id, :name, :subcategories] , operator: :and }  }, sort: { id: "desc" }, size: self.count }
    end

    #armar indexado de elasticserch
    def as_indexed_json(options={})
      {
        id: self.id.to_s,
        name:  self.name,
        subcategories: self.subcategories.map { |subcategory| subcategory.name } .join(", ")
      }.as_json
    end

    def self.search_field
      :name_cont
    end

    private

    def create_permalink
      self.permalink = self.name.downcase.parameterize
    end

  end
end
