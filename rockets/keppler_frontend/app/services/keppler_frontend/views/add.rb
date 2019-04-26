# frozen_string_literal: true

module KepplerFrontend
  module Views
  # Assets
    class Add
      def initialize; end

      def new_file(obj)
        file_format = ".html.#{obj[:view_format]}"
        name = "#{views_folder}/#{obj[:name]}#{file_format}"
        if obj[:view_format].eql?('haml')          
          create_file(name, "%h1 #{obj[:name].capitalize} Template")
        else
          create_file(name, "<h1> #{obj[:name].capitalize} Template </h1>")
        end
      end

      def new_route(obj)
        lines = File.readlines(routes)
        lines = lines.split('\n').first
        idx = code(lines).search_line(point)
        lines.insert(idx + 1, template(obj))
        File.write(routes, lines.join)
      end

      private

      def rocket_url
        'rockets/keppler_frontend'
      end

      def views_folder
        "#{rocket_url}/app/views/keppler_frontend/app/frontend"
      end

      def routes
        "#{rocket_url}/config/routes.rb"
      end

      def point
        "KepplerFrontend::Engine.routes.draw do"
      end

      def template(obj)
        "  #{obj[:method].downcase} '#{obj[:url]}', to: 'app/frontend##{obj[:name]}', as: :#{obj[:name]}\n"
      end

      def code(lines)
        KepplerFrontend::Utils::CodeSearch.new(lines)
      end

      def create_file(name, content)
        File.open(name, "w") {|f| f.write(content) }
      end
    end
  end
end