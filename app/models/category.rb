# Category Model
class Category < ActiveRecord::Base
  include ActivityHistory
  include CloneRecord
  has_many :shops

  # Fields for the search form in the navbar
  def self.search_field
    :icon_or_name_cont
  end
end
