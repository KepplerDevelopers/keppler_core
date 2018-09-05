# frozen_string_literal: true

# Keppler
module Uploadable
  extend ActiveSupport::Concern
  included do
    require 'csv'

    def self.upload(file)
      CSV.foreach(file.path, headers: true) { |row| create! row.to_hash }
    end
  end
end
