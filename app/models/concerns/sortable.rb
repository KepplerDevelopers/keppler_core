# Keppler
module Sortable
  extend ActiveSupport::Concern

  def self.sorter(params)
    params.each_with_index { |id, idx| find(id).update(position: idx.to_i + 1) }
  end
end
