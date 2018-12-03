# frozen_string_literal: true

module KepplerFrontend
  module Views
    # CodeHandler
    class HtmlHandler
      def initialize(view_data)
        @view = view_data
        @file = front.view(@view.name)
      end

      def install
        out_file = File.open(@file, 'w')
        out_file.puts(template)
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
        File.rename(@file, front.view(name))
        true
      rescue StandardError
        false
      end

      def output
        html = File.readlines(@file)
        idx_one, idx_two = search(html).search_section(point_one, point_two)
        html = html[idx_one + 1..idx_two - 1]
        html.join('')
      rescue StandardError
        false
      end

      def save(input)
        File.delete(@file) if File.exist?(@file)
        out_file = File.open(@file, 'w')
        out_file.puts(save_template(input))
        out_file.close
        true
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

      def save_template(input)
        "<keppler-view id='#{@view.name}'>\n" \
        "  #{input}\n" \
        '</keppler-view>'
      end
    end
  end
end
