# frozen_string_literal: true

module KepplerFrontend
  module Views
    # Assets
    class Views
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

      def add(obj)
        view_add.new_file(obj)
        view_add.new_route(obj)
      end

      def remove(file)
        view_remove.remove_file(file)
        view_remove.remove_route(file)
      end

      private

      def rocket_url
        'rockets/keppler_frontend'
      end

      def files
        "#{rocket_url}/app/views/keppler_frontend/app/**/*"
      end

      def routes
        KepplerFrontend::Views::RoutesHandler.new
      end

      def view_add
        KepplerFrontend::Views::Add.new
      end

      def view_remove
        KepplerFrontend::Views::Remove.new
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
end
