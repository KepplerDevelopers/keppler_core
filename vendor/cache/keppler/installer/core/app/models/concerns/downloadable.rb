# frozen_string_literal: true

# Keppler
module Downloadable
  extend ActiveSupport::Concern
  included do
    require 'csv'

    def self.to_csv(options = {})
      CSV.generate(options) do |csv|
        csv << column_names
        all.each { |object| csv << object.attributes.values }
      end
    end
  end
end
