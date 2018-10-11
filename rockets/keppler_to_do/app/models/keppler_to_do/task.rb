# frozen_string_literal: true

module KepplerToDo
  # Task Model
  class Task < ApplicationRecord
    include ActivityHistory
    include CloneRecord
    include Uploadable
    include Downloadable
    include Sortable
    include Searchable
    acts_as_list
    acts_as_paranoid

    def self.index_attributes
      %i[name]
    end
  end
end
