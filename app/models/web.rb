# Web Model
class Web < ActiveRecord::Base
  include ActivityHistory
  include CloneRecord

  # Fields for the search form in the navbar
  def self.search_field
    :headline_or_name_cont
  end
end
