# GoogleAnayticsTrack Model
class GoogleAnalyticsTrack < ActiveRecord::Base
  include ActivityHistory

  def self.get_tracking_id(request)
    find_by_url(request.url)
  end

  def self.search_field
    :name_or_tracking_id_cont
  end
end
