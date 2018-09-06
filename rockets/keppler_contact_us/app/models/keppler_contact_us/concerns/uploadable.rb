# frozen_string_literal: true

# KepplerContactUs
module KepplerContactUs
  module Concerns
    # Keppler
    module Uploadable
      extend ActiveSupport::Concern

      require 'csv'

      def self.upload(file)
        CSV.foreach(file.path, headers: true) { |row| create! row.to_hash }
      end
    end
  end 
end