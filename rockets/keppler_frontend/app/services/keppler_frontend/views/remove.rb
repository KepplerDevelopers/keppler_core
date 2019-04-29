# frozen_string_literal: true

module KepplerFrontend
  module Views
  # Assets
    class Remove
      def initialize; end

      def remove_file(file)
        directory = "#{views_folder}#{file}"
        File.delete(directory) if File.exist?(directory)
      end

      def remove_route(file)
        lines = File.readlines(routes)
        lines = lines.split('\n').first
        lines.each_with_index do |line, i|
          if line.include?(template(file))
            lines.delete_at(i)
          end
        end
        File.write(routes, lines.join)
      end

      private

      def rocket_url
        'rockets/keppler_frontend'
      end

      def views_folder
        "#{rocket_url}/app/views/keppler_frontend/app"
      end

      def routes
        "#{rocket_url}/config/routes.rb"
      end

      def template(file)
        file = file.split('/')
        controller = file.second
        action = file.last.split('.').first
        "app/#{controller}##{action}"
      end

      def code(lines)
        KepplerFrontend::Utils::CodeSearch.new(lines)
      end
    end
  end
end