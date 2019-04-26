module KepplerFrontend
  module Views
    # Assets
    class RoutesHandler
      def initialize; end

      def list
        routes = KepplerFrontend::Engine.routes.routes
        routes.map do |route|
          setting = "#{route.defaults[:controller]}/" +
                    "#{route.defaults[:action]}"
          [ route.path.spec.to_s, 
            setting 
          ]
        end
      end
        
      def search_route(file)
        route = ''
        routes_lines.each do |line|
          if controller_and_action?(file, line)
            route = route_format(line)
          end
        end
        route
      end

      def route_method(file)
        method = ''
        routes_lines.each do |line|
          if controller_and_action?(file, line)
            method = line.split(' ').first
          end
        end
        method
      end

      private
      
      def routes_url
        'rockets/keppler_frontend/config/routes.rb'
      end

      def route_format(route)
        route = route.split(' ').second
        route.gsub!("'", '')
        route.gsub!(",", '')
      end

      def routes_lines
        File.readlines(routes_url)
      end
      
      def controller_and_action?(file, route)
        file = file.split('.').first
        controller = file.split('/').second
        action = file.split('/').last
        route.include?("#{controller}##{action}")
      end
    end
  end
end