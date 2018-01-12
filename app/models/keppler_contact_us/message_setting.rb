#Generado por keppler
module KepplerContactUs
  class MessageSetting < ActiveRecord::Base
    include CloneRecord

    # Fields for the search form in the navbar
    def self.search_field
      :mailer_to_or_mailer_from
    end
  end
  #MessageSetting.import
end
