# frozen_string_literal: true

module KepplerFrontend
  module LiveEditor
    # CssHandler
    class NoEditArea
      def initialize(html_original_lines)
        @html_original = html_original_lines
      end

      def ids
        doc = Nokogiri::HTML(@html_original.join)
        nodes = []
        doc.css('keppler-no-edit').each do |link|
          nodes << [link.attribute('id').value]
        end
        nodes
      end

      def code_no_edit(ids)
        ids.each_with_index do |id, idx|
          idx_section = search_area(@html_original, id.first)
          ids[idx] << @html_original[ idx_section[0]..idx_section[1] ]
        end
      end

      def merge_to(html_editor)
        code_no_edit(ids).each do |code|
          next if delete_empty_areas?(html_editor, code)
          idx_section = search_area(html_editor, code.first)
          html_editor = fusion(html_editor, code, idx_section)
        end
        html_editor
      end

      private

      def code_search(html)
        KepplerFrontend::Utils::CodeSearch.new(html)
      end

      def search_area(html, id)
        find = code_search(html)
        find.search_section("id=\"#{id}\"", '</keppler-no-edit>')
      end

      def delete_empty_areas?(html_editor, code)
        find = code_search(html_editor)
        line = "id=\"#{code.first}\"></keppler-no-edit>"
        idx_empty = find.search_line(line)
        !idx_empty.zero? ? html_editor.slice!(idx_empty) : false
      end

      def fusion(html_editor, code, idx_section)
        idx_begin = idx_section[0]
        idx_end = idx_section[1]
        html_editor.slice!(idx_begin + 1..idx_end - 1)
        return html_editor if idx_begin.zero?
        code_last = code.last
        code_last[1..code_last.length - 2].reverse.each do |line|
          html_editor.insert(idx_begin + 1, "#{line}\n")
        end
        html_editor
      end
    end
  end
end
