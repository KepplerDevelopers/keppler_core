# frozen_string_literal: true

# StringActions Module
module KepplerFrontend
  module Concerns
    module StringActions
      extend ActiveSupport::Concern
      private

      def not_special_chars
        ('a'..'z').to_a << '_'
      end
    end
  end
end
