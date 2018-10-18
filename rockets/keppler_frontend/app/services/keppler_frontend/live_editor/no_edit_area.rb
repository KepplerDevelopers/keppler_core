# frozen_string_literal: true

module KepplerFrontend
  module LiveEditor
    # CssHandler
    class NoEditArea
      def initialize; end

      def ids(section)
        doc = Nokogiri::HTML(section)
        nodes = []
        doc.css('keppler-no-edit').each do |link|
          nodes << [link.attribute('id').value]
        end
        nodes
      end
    end
  end
end
