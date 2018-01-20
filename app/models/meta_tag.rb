# MetaTag Model
class MetaTag < ActiveRecord::Base
  include ActivityHistory
  include CloneRecord
  acts_as_list
  validates_uniqueness_of :url

  def self.get_by_url(url)
    url = url.split('//').last.split('/').join('/')
    find_by_url(url)
  end

  def self.search_field
    :title_or_description_or_url_cont_any
  end

  def self.sorter(params)
    params.each_with_index do |id, idx|
      self.find(id).update(position: idx.to_i+1)
    end
  end
end
