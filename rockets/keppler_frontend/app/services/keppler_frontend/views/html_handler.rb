# frozen_string_literal: true

module KepplerFrontend
  module Views
    # CodeHandler
    class HtmlHandler
      def initialize(view_data)
        @view = view_data
      end

      def install
        out_file = File.open(front.view(@view.name), 'w')
        out_file.puts(template)
        begin
          out_file.close
          true
        rescue StandardError
          false
        end
      end

      def uninstall
        file = front.view(@view.name)
        begin
          File.delete(file) if File.exist?(file)
          true
        rescue StandardError
          false
        end
      end

      private

      def front
        KepplerFrontend::Urls::Front.new
      end

      def template
        "<keppler-view id=\"#{@view.name}\">\n" \
        "  <h1> #{@view.name} template </h1>\n" \
        '</keppler-view>'
      end
    end
  end
end
