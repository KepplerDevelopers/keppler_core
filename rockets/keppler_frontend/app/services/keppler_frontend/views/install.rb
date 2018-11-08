# frozen_string_literal: true

module KepplerFrontend
  module Views
    # CodeHandler
    class Install
      def initialize(view_data)
        @view = view_data
      end

      def install
        case @view.format_result
        when 'HTML'
          install_html
        when 'JS'
          install_remote_js
        when 'Action'
          install_only_action
        end
      rescue StandardError
        false
      end

      def install_html
        service('actions').install
        service('html').install
        service('css').install
        service('js').install
        service('routes').install
      rescue StandardError
        false
      end

      def install_remote_js
        service('routes').install
        service('actions').install
        service('remote_js').install
      rescue StandardError
        false
      end

      def install_only_action
        service('routes').install
        service('actions').install
      rescue StandardError
        false
      end

      private

      def service(name)
        model = "KepplerFrontend::Views::#{name.camelize}Handler"
        model.constantize.new(@view)
      end
    end
  end
end
