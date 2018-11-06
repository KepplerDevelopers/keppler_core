# frozen_string_literal: true

module KepplerFrontend
  module Views
    # CodeHandler
    class RemoteJsHandler
      def initialize(view_data)
        @view = view_data
      end

      def install
        out_file = File.open(view_js, 'w')
        out_file.puts("// #{@view.name} javascript Erb template")
        out_file.close
        true
      rescue StandardError
        false
      end

      def uninstall
        File.delete(view_js) if File.exist?(view_js)
        true
      rescue StandardError
        false
      end

      private

      def view_js
        front = KepplerFrontend::Urls::Front.new
        front.view_js(@view.name)
      end
    end
  end
end
