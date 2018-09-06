# frozen_string_literal: true

# KepplerContactUs
module KepplerContactUs
  module Concerns
    # Keppler
    module CloneRecord
      extend ActiveSupport::Concern

      # Class Methods
      module ClassMethods
        def clone_record(id)
          object = name.constantize.find(id)
          object.dup
        end
      end
    end
  end 
end