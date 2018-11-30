# frozen_string_literal: true

module KepplerFrontend
  module Views
    # CodeHandler
    class Output
      def initialize(view_data)
        @view = view_data
      end

      def html
        service('html').output
      rescue StandardError
        false
      end

      def action
        service('actions').output
      rescue StandardError
        false
      end

      def scss
        service('css').output
      rescue StandardError
        false
      end

      def js
        service('js').output
      rescue StandardError
        false
      end

      def remote_js
        service('remote_js').output
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
