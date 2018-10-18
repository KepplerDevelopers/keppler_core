# frozen_string_literal: true

module KepplerFrontend
  module LiveEditor
    # CssHandler
    class CssHandler
      def initialize(view_name)
        @view_name = view_name
        @urls = KepplerFrontend::Urls::Assets.new
        @core_css_app = @urls.core_assets('stylesheets', 'app')
      end

      def output
        css_url = "#{@core_css_app}/views/#{@view_name}.scss"
        begin
          lines = File.readlines(css_url)
          lines = lines.select { |l| l unless l.include?('//') }
          lines.join
        rescue StandardError
          nil
        end
      end

      def save(css)
        file = "#{@core_css_app}/views/#{@view_name}.scss"
        File.delete(file) if File.exist?(file)
        out_file = File.open(file, 'w')
        out_file.puts(css)
        out_file.close
      end
    end
  end
end
