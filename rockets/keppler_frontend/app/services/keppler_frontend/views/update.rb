# frozen_string_literal: true

module KepplerFrontend
  module Views
    # CodeHandler
    class Update
      def initialize(view_data)
        @view = view_data
      end

      def change_name(name)
        case @view.format_result
        when 'HTML'
          update_html(name)
        when 'JS'
          update_remote_js(name)
        when 'Action'
          update_only_action(name)
        end
      rescue StandardError
        false
      end

      def update_html(name)
        service('actions').update(name)
        service('html').update(name)
        service('css').update(name)
        service('js').update(name)
        true
      rescue StandardError
        false
      end

      def update_remote_js(name)
        service('actions').update(name)
        service('remote_js').update(name)
        true
      rescue StandardError
        false
      end

      def update_only_action(name)
        service('actions').update(name)
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
