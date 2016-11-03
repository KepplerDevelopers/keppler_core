# GoogleAdword Model
class GoogleAdword < ActiveRecord::Base
  include ActivityHistory

  def self.get_by_url(url)
    find_by_url(url)
  end

  def self.search_field
    :campaign_name_or_description_cont
  end
end
