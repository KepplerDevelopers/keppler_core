# frozen_string_literal: true

module KepplerFrontend
  module Views
    # CodeHandler
    class CssHandler
      def initialize(view_data)
        @view = view_data
      end

      def install
        out_file = File.open(view_css, 'w')
        out_file.puts("/* Keppler - #{@view.name}.scss file */")
        out_file.close
        true
      rescue StandardError
        false
      end

      def uninstall
        File.delete(view_css) if File.exist?(view_css)
        true
      rescue StandardError
        false
      end

      private

      def view_css
        assets = KepplerFrontend::Urls::Assets.new
        assets = assets.core_assets('stylesheets', 'app')
        "#{assets}/views/#{@view.name}.scss"
      end
    end
  end
end
