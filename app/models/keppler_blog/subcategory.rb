module KepplerBlog
  class Subcategory < ActiveRecord::Base
  	before_save :create_permalink
  	belongs_to :category
  	has_many :posts

  	private
  	
  	def create_permalink
      self.permalink = self.name.downcase.parameterize
    end
  end
end
