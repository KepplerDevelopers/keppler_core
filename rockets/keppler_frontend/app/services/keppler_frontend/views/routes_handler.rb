# frozen_string_literal: true

module KepplerFrontend
  module Views
    # CodeHandler
    class RoutesHandler
      def initialize(view_data)
        @view = view_data
      end

      def install
        routes_file = File.readlines(config.routes)
        idx = code_search(routes_file).search_line(flag_point)
        routes_file.insert(idx.to_i + 1, template)
        routes_file = routes_file.join('')
        File.write(config.routes, routes_file)
        true
      rescue StandardError
        false
      end

      def uninstall
        routes_file = File.readlines(config.routes)
        idx = code_search(routes_file).search_line(template)
        return if idx.zero?
        routes_file.delete_at(idx.to_i)
        routes_file = routes_file.join('')
        File.write(config.routes, routes_file)
        true
      rescue StandardError
        false
      end

      private

      def config
        KepplerFrontend::Urls::Config.new
      end

      def flag_point
        'KepplerFrontend::Engine.routes.draw do'
      end

      def template
        active = @view.active.eql?(false) ? '#' : ''
        "#{active}  #{@view.method.downcase} '#{@view.url}'," \
            " to: 'app/frontend##{@view.name}', as: :#{@view.name}\n"
      end

      def code_search(html)
        KepplerFrontend::Utils::CodeSearch.new(html)
      end
    end
  end
end
