# frozen_string_literal: true

module KepplerFrontend
  module Views
    # CodeHandler
    class JsHandler
      def initialize(view_data)
        @view = view_data
        @file = view_js(@view.name)
      end

      def install
        out_file = File.open(@file, 'w')
        out_file.puts(template)
        out_file.close
        true
      rescue StandardError
        false
      end

      def uninstall
        File.delete(@file) if File.exist?(@file)
        true
      rescue StandardError
        false
      end

      def output
        File.read(@file)
      rescue StandardError
        false
      end

      def update(name)
        File.rename(@file, view_js(name))
        true
      rescue StandardError
        false
      end

      def save(input)
        File.delete(@file) if File.exist?(@file)
        out_file = File.open(@file, 'w')
        out_file.puts(input)
        out_file.close
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
