# frozen_string_literal: true

module KepplerFrontend
  module Views
    # CodeHandler
    class JsHandler
      def initialize(view_data)
        @view = view_data
      end

      def install
        out_file = File.open(view_js, 'w')
        out_file.puts(template)
        out_file.close
        true
      rescue StandardError
        false
      end

      def uninstall
        File.delete(view_js) if File.exist?(view_js)
        true
      rescue StandardError
        false
      end

      private

      def view_js
        assets = KepplerFrontend::Urls::Assets.new
        assets = assets.core_assets('javascripts', 'app')
        "#{assets}/views/#{@view.name}.js"
      end

      def template
        "// Keppler - #{@view.name}.js file\n" \
        "$(document).ready(function(){\n" \
        "  // Use jquery functions here\n" \
        '});'
      end
    end
  end
end
