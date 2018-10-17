# frozen_string_literal: true

module KepplerFrontend
  module Urls
    # Assets
    class Assets
      def initialize
        @root = KepplerFrontend::Urls::Roots.new
      end

      def core_assets(asset_type, side)
        "#{@root.rocket_root}/app/assets/#{asset_type}/keppler_frontend/#{side}"
      end

      def front_assets(file)
        "/assets/keppler_frontend/app/#{file}"
      end
    end
  end
end
