# frozen_string_literal: true

module KepplerFrontend
  module Urls
    # Assets
    class Config
      def initialize; end

      def routes
        "#{root.rocket_root}/config/routes.rb"
      end

      def yml(file_name)
        "#{root.rocket_root}/config/data/#{file_name}.yml"
      end

      private

      def root
        KepplerFrontend::Urls::Roots.new
      end
    end
  end
end
