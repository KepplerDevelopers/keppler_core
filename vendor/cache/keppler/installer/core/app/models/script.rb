# frozen_string_literal: true

# Script Model
class Script < ApplicationRecord
  include ActivityHistory
  include CloneRecord
  include Uploadable
  include Downloadable
  include Sortable
  acts_as_list

  validates_presence_of :name, :script, :url

  def self.get_script(request)
    find_by_url(request.url)
  end

  def self.search_field
    :name_or_script_cont
  end
end
