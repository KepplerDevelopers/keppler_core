# Shop Model
class Shop < ActiveRecord::Base
  include ActivityHistory
  include CloneRecord
  belongs_to :category

  # Fields for the search form in the navbar
  def self.search_field
    :image_or_name_or_category_id_cont
  end
end
