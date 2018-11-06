# frozen_string_literal: true

module KepplerFrontend
  module Urls
    # Roots
    class Roots
      def initialize; end

      def keppler_root
        Rails.root
      end

      def rocket_root
        "#{keppler_root}/rockets/keppler_frontend"
      end
    end
  end
end
