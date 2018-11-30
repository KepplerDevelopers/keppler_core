# frozen_string_literal: true

module KepplerFrontend
  module Views
    # CodeHandler
    class CssHandler
      def initialize(view_data)
        @view = view_data
      end

      def install
        out_file = File.open(view_css(@view.name), 'w')
        out_file.puts("/* Keppler - #{@view.name}.scss file */")
        out_file.close
        true
      rescue StandardError
        false
      end

      def uninstall
        if File.exist?(view_css(@view.name))
          File.delete(view_css(@view.name))
        end
        true
      rescue StandardError
        false
      end

      def update(name)
        old_name = view_css(@view.name)
        new_name = view_css(name)
        File.rename(old_name, new_name)
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
