# frozen_string_literal: true

# StringActions Module
module KepplerCapsules
  module Concerns
    module StringActions
      extend ActiveSupport::Concern

      private

      def special_characters
        [
          '/', '.', '@', '"', "'", '%', '&', '$',
          '?', '¿', '/', '=', ')', '(', '#', '{',
          '}', ',', ';', ':', '[', ']', '^', '`',
          '¨', '~', '+', '-', '*', '¡', '!', '|',
          '¬', '°', '<', '>', '·', '½'
        ]
      end
    end
  end
end
