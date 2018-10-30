# frozen_string_literal: true

module KepplerFrontend
  module LiveEditor
    # HtmlHandler
    class HtmlHandler
      def initialize(view_name)
        @view_name = view_name
      end

      def save(html_editor)
        html_original = build_html(utils.lines('layout'), utils.lines('view'))
        no_edit_area = no_edit_area(html_original)
        html_processed = no_edit_area.merge_to(html_editor.split("\n"))
        %w[header view footer].each do |area|
          save_area(area, html_processed)
        end
      end

      def save_area(area, html_processed)
        idx_first, idx_last = utils.find_area(html_processed, area)
        return if idx_last.zero?
        area_edit = html_processed[idx_first..idx_last]
        update(area, area_edit)
      end

      private

      def front
        KepplerFrontend::Urls::Front.new
      end

      def no_edit_area(html_original)
        NoEditArea.new(html_original)
      end

      def utils
        HtmlSaveUtils.new(@view_name)
      end

      def code_search(html)
        KepplerFrontend::Utils::CodeSearch.new(html)
      end

      def build_html(layout_original, view_original)
        yield_label = code_search(layout_original).search_line('yield')
        layout_original.slice!(yield_label)
        point = code_search(layout_original).search_line('</keppler-header>')
        view_original.reverse.each do |line|
          layout_original.insert(point + 1, line)
        end
        layout_original
      end

      def update(area, area_edit)
        origin_code = utils.lines(area)
        idx_first, idx_last = utils.find_area(origin_code, area)
        origin_code = add_new_code(origin_code, area_edit, idx_first, idx_last)
        File.write(utils.url(area), HtmlBeautifier.beautify(origin_code))
        origin_code
      end

      def add_new_code(origin_code, area_edit, idx_first, idx_last)
        origin_code.slice!(idx_first + 1..idx_last - 1)
        area_edit[1..area_edit.length - 2].reverse.each do |line|
          origin_code.insert(idx_first + 1, "#{line}\n")
        end
        origin_code.insert(idx_first + 1, "<!-- Keppler Section -->\n")
        origin_code.join
      end
    end
  end
end
