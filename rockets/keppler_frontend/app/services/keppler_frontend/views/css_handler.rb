# frozen_string_literal: true

module KepplerFrontend
  module Views
    # CodeHandler
    class CssHandler
      def initialize(view_data)
        @view = view_data
        @file = view_css(@view.name)
      end

      def install
        out_file = File.open(@file, 'w')
        out_file.puts("/* Keppler - #{@view.name}.scss file */")
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
        File.rename(@file, view_css(name))
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

      def view_css(name)
        assets = KepplerFrontend::Urls::Assets.new
        assets = assets.core_assets('stylesheets', 'app')
        "#{assets}/views/#{name}.scss"
      end
    end
  end
end
