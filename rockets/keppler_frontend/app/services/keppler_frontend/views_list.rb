# frozen_string_literal: true

module KepplerFrontend
  # Assets
  class ViewsList
    def initialize; end

    def all
      files_name = []
      Dir[files].each do |file|
        file = file.split('app').last
        if permit?(file)
          files_name <<  file 
        end
      end
      files_name
    end

    def all_with_routes
      all.map do |file|
        [file, 
         routes.search_route(file),
         routes.route_method(file)]
      end
    end

    private

    def rocket_url
      'rockets/keppler_frontend'
    end

    def files
      "#{rocket_url}/app/views/keppler_frontend/app/**/*"
    end

    def routes
      KepplerFrontend::RoutesHandler.new
    end

    def format_permit?(file)
      file_format = file.split('.')
      ext1 = ['haml', 'erb'].include?(file_format.last)
      ext2 = ['html'].include?(file_format.second)
      ext1 && ext2
    end

    def partial?(file)
      file.split('/').last.first.eql?('_')
    end

    def permit?(file)
      !partial?(file) && 
      format_permit?(file) &&
      !file.include?('keppler.')
    end
  end
end
