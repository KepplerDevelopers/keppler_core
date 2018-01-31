# Script Model
class Script < ActiveRecord::Base
  include ActivityHistory
  include CloneRecord

  validates_presence_of :name, :script, :url

  def self.get_script(request)
    find_by_url(request.url)
  end

  def self.search_field
    :name_or_script_cont
  end
end
