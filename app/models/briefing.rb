# Briefing Model
class Briefing < ActiveRecord::Base
  include ActivityHistory
  include CloneRecord

  # Fields for the search form in the navbar
  def self.search_field
    :name_or_email_or_phone_or_company_or_services_type_or_other_or_about_cont
  end
end
