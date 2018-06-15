# frozen_string_literal: true

# Keppler
module Sortable
  extend ActiveSupport::Concern
  included do
    def self.sorter(params)
      params.each_with_index { |i, id| find(i).update(position: id.to_i + 1) }
    end
  end
end
