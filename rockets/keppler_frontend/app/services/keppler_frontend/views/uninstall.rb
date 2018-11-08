# frozen_string_literal: true

module KepplerFrontend
  module Views
    # CodeHandler
    class Uninstall
      def initialize(view_data)
        @view = view_data
      end

      def uninstall
        case @view.format_result
        when 'HTML'
          uninstall_html
        when 'JS'
          uninstall_remote_js
        when 'Action'
          uninstall_only_action
        end
      rescue StandardError
        false
      end

      def uninstall_html
        service('routes').uninstall
        service('actions').uninstall
        service('html').uninstall
        service('css').uninstall
        service('js').uninstall
        true
      rescue StandardError
        false
      end

      def uninstall_remote_js
        service('routes').uninstall
        service('actions').uninstall
        service('remote_js').uninstall
        true
      rescue StandardError
        false
      end

      def uninstall_only_action
        service('routes').uninstall
        service('actions').uninstall
        true
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
