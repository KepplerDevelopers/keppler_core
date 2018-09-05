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

      def without_special_characters
        self.name.gsub!(' ', '_')
        special_characters.each { |sc| self.name.gsub!(sc, '') }
      end

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
