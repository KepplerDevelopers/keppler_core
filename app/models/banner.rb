# Banner Model
class Banner < ActiveRecord::Base
  include ActivityHistory
  include CloneRecord

  # Fields for the search form in the navbar
  def self.search_field
    :cover_or_category_id_cont
  end
end
