# frozen_string_literal: true

module KepplerFrontend
  module Utils
    # CodeHandler
    class CodeSearch
      def initialize(html_lines)
        @html_lines = html_lines
      end

      def search_section(point_one, point_two)
        idx = [0, 0]
        idx = begin_index(point_one, idx)
        end_index(point_two, idx)
      end

      def search_line(point)
        idx = [0]
        idx = begin_index(point, idx)
        idx.first
      end

      private

      def begin_index(point_one, idx)
        @html_lines.each do |line|
          idx[0] = @html_lines.find_index(line) if line.include?(point_one)
        end
        idx
      end

      def end_index(point_two, idx)
        @html_lines[idx[0]..@html_lines.size].each do |line|
          next unless line.include?(point_two)
          html_lines = @html_lines[idx[0]..@html_lines.size]
          idx[1] = idx[0] + html_lines.find_index(line)
          break if (idx[1]).positive?
        end
        idx
      end
    end
  end
end
