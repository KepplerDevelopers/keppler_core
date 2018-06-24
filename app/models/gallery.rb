# frozen_string_literal: true

# Gallery Model
class Gallery < ApplicationRecord
  include ActivityHistory
  include CloneRecord
  include Uploadable
  include Downloadable
  include Sortable
  acts_as_list
  acts_as_paranoid

  # Fields for the search form in the navbar
  def self.search_field
    fields = %i[avatar images video audio pdf txt files position deleted_at]
    build_query(fields, :or, :cont)
  end

  # Funcion para armar el query de ransack
  def self.build_query(fields, operator, conf)
    query = fields.join("_#{operator}_")
    query << "_#{conf}"
    query.to_sym
  end
end
