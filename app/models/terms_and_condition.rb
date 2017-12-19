# TermsAndCondition Model
class TermsAndCondition < ActiveRecord::Base
  include ActivityHistory
  include CloneRecord

  # Fields for the search form in the navbar
  def self.search_field
    :content_cont
  end
end
