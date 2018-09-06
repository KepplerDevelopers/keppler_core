# Message Model
module KepplerContactUs
  class Message < ApplicationRecord
    include KepplerContactUs::Concerns::Messageable
    include KepplerContactUs::Concerns::ActivityHistory
    include KepplerContactUs::Concerns::CloneRecord
    include KepplerContactUs::Concerns::Uploadable
    include KepplerContactUs::Concerns::Downloadable
    include KepplerContactUs::Concerns::Sortable
    acts_as_list

    def self.reject_current_user_email
      all.reject { |x| x.from_email.eql?(current_user.email) }
    end

    # Fields for the search form in the navbar
    def self.search_field
      fields = %w[name from_email to_emails subject content]
      build_query(fields, :or, :cont)
    end

    # Funcion para armar el query de ransack
    def self.build_query(fields, operator, conf)
      query = fields.join("_#{operator}_")
      query << "_#{conf}"
      query.to_sym
    end
  end
end
