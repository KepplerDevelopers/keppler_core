# frozen_string_literal: true

module KepplerFrontend
  module Callbacks
    # CodeHandler
    class CodeHandler
      def initialize(callback_data)
        @callback = callback_data
        @file = front.controller
      end

      def install
        ctrl = File.readlines(@file)
        idx = search(ctrl).search_line(flag_point)
        add_function(ctrl, idx.to_i)
        File.write(@file, ctrl.join(''))
        true
      rescue StandardError
        false
      end

      def uninstall
        ctrl = File.readlines(@file)
        idx_one, idx_two = search(ctrl).search_section(point_one, point_two)
        return if idx_one.zero?
        ctrl.slice!(idx_one..idx_two)
        File.write(@file, ctrl.join(''))
        true
      rescue StandardError
        false
      end

      private

      def front
        KepplerFrontend::Urls::Front.new
      end

      def flag_point
        '    private'
      end

      def point_one
        "    # begin callback #{@callback.name}\n"
      end

      def point_two
        "    # end callback #{@callback.name}\n"
      end

      def search(html)
        KepplerFrontend::Utils::CodeSearch.new(html)
      end

      def add_function(ctrl, idx)
        ctrl.insert(idx + 1, "    # begin callback #{@callback.name}\n")
        ctrl.insert(idx + 2, "    def #{@callback.name}\n")
        ctrl.insert(idx + 3, "      # Insert ruby code...\n")
        ctrl.insert(idx + 4, "    end\n")
        ctrl.insert(idx + 5, "    # end callback #{@callback.name}\n")
      end
    end
  end
end
