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
        out_file.close
        true
      rescue StandardError
        false
      end

      def uninstall
        file = front.view(@view.name)
        File.delete(file) if File.exist?(file)
        true
      rescue StandardError
        false
      end

      def update(name)
        old_name = front.view(@view.name)
        new_name = front.view(name)
        File.rename(old_name, new_name)
        true
      rescue StandardError
        false
      end

      def output
        html = File.readlines(front.view(@view.name))
        idx_one, idx_two = search(html).search_section(point_one, point_two)
        html = html[idx_one + 1..idx_two - 1]
        html.join('')
      rescue StandardError
        false
      end

      private

      def search(html)
        KepplerFrontend::Utils::CodeSearch.new(html)
      end

      def point_one
        "<keppler-view id='#{@view.name}'\n"
      end

      def point_two
        "</keppler-view>\n"
      end

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
