# frozen_string_literal: true

module KepplerFrontend
  module LiveEditor
    # HtmlHandler
    class HtmlSaveUtils
      def initialize(view_name)
        @view_name = view_name
      end

      def lines(origin)
        url_assigned = url(origin)
        File.readlines(url_assigned)
      end

      def url(origin)
        origin.eql?('view') ? front.view(@view_name) : front.layout
      end

      def find_area(html_processed, area)
        label = label_area(area)
        find = code_search(html_processed)
        find.search_section(label.tr("'", '\"'), "</keppler-#{area}>")
      end

      private

      def front
        KepplerFrontend::Urls::Front.new
      end

      def code_search(html)
        KepplerFrontend::Utils::CodeSearch.new(html)
      end

      def label_area(area)
        label_one = "<keppler-#{area}"
        label_two = "<keppler-#{area} id='#{@view_name}'"
        !area.eql?('view') ? label_one : label_two
      end
    end
  end
end
