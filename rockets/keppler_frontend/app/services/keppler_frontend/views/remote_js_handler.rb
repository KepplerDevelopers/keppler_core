# frozen_string_literal: true

module KepplerFrontend
  module Views
    # CodeHandler
    class RemoteJsHandler
      def initialize(view_data)
        @view = view_data
        @file = view_js(@view.name)
      end

      def install
        out_file = File.open(@file, 'w')
        out_file.puts("// #{@view.name} javascript Erb template")
        out_file.close
        true
      rescue StandardError
        false
      end

      def uninstall
        File.delete(@file) if File.exist?(@file)
        true
      rescue StandardError
        false
      end

      def update(name)
        File.rename(@file, view_js(name))
        true
      rescue StandardError
        false
      end

      def output
        remote_js = File.readlines(@file)
        remote_js.join
      rescue StandardError
        false
      end

      def save(input)
        File.delete(@file) if File.exist?(@file)
        out_file = File.open(@file, 'w')
        out_file.puts(input)
        out_file.close
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
