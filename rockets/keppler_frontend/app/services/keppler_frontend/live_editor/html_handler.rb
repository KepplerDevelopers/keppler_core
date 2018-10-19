# frozen_string_literal: true

module KepplerFrontend
  module LiveEditor
    # HtmlHandler
    class HtmlHandler
      def initialize(view_name)
        @view_name = view_name
      end

      def save(html_editor)
        original_view = File.readlines(front_url.view(@view_name))
        original_layout = File.readlines(front_url.layout)
        html_original = build_html(original_layout, original_view)
        no_edit_area = no_edit_area(html_original)
        html_processed = no_edit_area.merge_to(html_editor.split("\n"))
        ['header', 'view', 'footer'].each do |area| 
          url =  area.eql?('view') ? front_url.view(@view_name) : front_url.layout
          save_area(area, url, html_processed)
        end
      end

      def save_area(area, origin_url, html_processed)
        idx_area = find_area(html_processed, area)
        return if idx_area[1].zero?
        area_edit = html_processed[idx_area[0]..idx_area[1]]
        update(area, area_edit, origin_url)
      end

      private

      def front_url
        KepplerFrontend::Urls::Front.new
      end

      def no_edit_area(html_original)
        KepplerFrontend::LiveEditor::NoEditArea.new(html_original)
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

      def label_area(area)
        label_one = "<keppler-#{area}"
        label_two = "<keppler-#{area} id='#{@view_name}'"
        !area.eql?('view') ? label_one : label_two
      end

      def find_area(html_processed, area)        
        label = label_area(area)
        find = code_search(html_processed)
        find.search_section(label.gsub("'", "\""), "</keppler-#{area}>")
      end   

      def update(area, area_edit, origin_url)
        origin_code = File.readlines(origin_url)
        origin_area = find_area(origin_code, area)
        origin_code.slice!(origin_area[0] + 1..origin_area[1] - 1)
        area_edit[1..area_edit.length - 2].reverse.each_with_index do |line, i|
          origin_code.insert(origin_area[0] + 1, "#{line}\n")
        end
        origin_code.insert(origin_area[0]+1, "<!-- Keppler Section -->\n")
        File.write(origin_url, HtmlBeautifier.beautify(origin_code.join('')))
        origin_code
      end
    end
  end
end
