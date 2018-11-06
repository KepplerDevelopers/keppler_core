# frozen_string_literal: true

module KepplerFrontend
  module LiveEditor
    # CssHandler
    class ImagesHandler
      def initialize; end

      def output
        images = Dir["#{core_app}/*"]
        arr = []
        images.each do |i|
          arr << { type: 'image', src: front_app(i.split('/').last).to_s }
        end
        arr
      end

      private

      def front_app(file)
        urls = KepplerFrontend::Urls::Assets.new
        urls.front_assets(file)
      end

      def core_app
        urls = KepplerFrontend::Urls::Assets.new
        urls.core_assets('images', 'app')
      end
    end
  end
end
