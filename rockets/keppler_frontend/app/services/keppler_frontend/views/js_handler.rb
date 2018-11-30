# frozen_string_literal: true

module KepplerFrontend
  module Views
    # CodeHandler
    class JsHandler
      def initialize(view_data)
        @view = view_data
      end

      def install
        out_file = File.open(view_js(@view.name), 'w')
        out_file.puts(template)
        out_file.close
        true
      rescue StandardError
        false
      end

      def uninstall
        File.delete(view_js(@view.name)) if File.exist?(view_js(@view.name))
        true
      rescue StandardError
        false
      end

      def output
        File.read(view_js(@view.name))
      rescue StandardError
        false
      end

      def update(name)
        old_name = view_js(@view.name)
        new_name = view_js(name)
        File.rename(old_name, new_name)
        true
      rescue StandardError
        false
      end

      private

      def view_js(name)
        assets = KepplerFrontend::Urls::Assets.new
        assets = assets.core_assets('javascripts', 'app')
        "#{assets}/views/#{name}.js"
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
