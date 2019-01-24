# frozen_string_literal: true

module KepplerFrontend
  module Views
    # CodeHandler
    class Save
      def initialize(view_data)
        @view = view_data
      end

      def code(type_code, code)
        service(type_code.to_s).save(code)
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
