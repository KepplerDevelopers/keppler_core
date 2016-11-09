# MetaTag Model
class MetaTag < ActiveRecord::Base
  include ActivityHistory
  include KepplerModel

  def self.get_by_url(url)
    find_by_url(url)
  end

  def self.search_field
    :title_or_description_or_url_cont
  end
end
