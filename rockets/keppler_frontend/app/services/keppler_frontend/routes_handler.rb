module KepplerFrontend
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
      result = ""
      file = file.split('.').first
      list.each do | route |
        if route.last.include?(file)
          result = route_format(route)
        end
      end
      result
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
      route.first.slice!('(.:format)')
      route.first
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