# frozen_string_literal: true

module KepplerFrontend
  module Views
    # CodeHandler
    class RemoteJsHandler
      def initialize(view_data)
        @view = view_data
      end

      def install
        out_file = File.open(view_js(@view.name), 'w')
        out_file.puts("// #{@view.name} javascript Erb template")
        out_file.close
        true
      rescue StandardError
        false
      end

      def uninstall
        if File.exist?(view_js(@view.name))
          File.delete(view_js(@view.name))
        end
        true
      rescue StandardError
        false
      end

      def update(name)
        old_name = view_js(@view.name)
        new_name = view_js(name)
        File.rename(old_name, new_name)
        true
      rescue StandardError
        false
      end

      private

      def view_js(name)
        front = KepplerFrontend::Urls::Front.new
        front.view_js(name)
      end
    end
  end
end
