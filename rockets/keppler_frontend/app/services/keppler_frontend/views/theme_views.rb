# frozen_string_literal: true

module KepplerFrontend
  module Views
  # Assets
    class ThemeViews
      def initialize; end

      def select_theme(config)
        erb?(config) ? paste_erb(config) : paste_haml(config)
      end

      private

      def rocket_url
        'rockets/keppler_frontend'
      end

      def views_folder
        "#{rocket_url}/app/views/keppler_frontend/app/"
      end

      def erb?(config)
        config[:view_format].eql?('erb')
      end

      def paste_erb(config)
        view = "#{views_folder}/#{config[:view]}"
        theme = "#{rocket_url}/app#{config[:theme]}"
        theme = File.readlines(theme)
        File.write(view, theme.join)
      end

      def paste_haml(config)
        view = "#{views_folder}/#{config[:view]}"
        theme = "#{rocket_url}/app#{config[:theme]}"
        theme = File.readlines(theme)
        File.write(view, theme.join)
        convert_to_haml(view)
      end

      def convert_to_haml(view)
        output = "#{views_folder}/output.haml}"
        system("html2haml --erb #{view} #{output}")
        theme = File.readlines(output)
        File.write(view, theme.join)
        File.delete(output) if File.exist?(output)
      end
    end
  end
end
