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

      def change_name(name)
        ctrl = File.readlines(@file)
        idx_one, idx_two = search(ctrl).search_section(point_one, point_two)
        return if idx_one.zero?
        update_function(ctrl, idx_one, idx_two, name)
        File.write(@file, ctrl.join(''))
        true
      rescue StandardError
        false
      end

      def output
        ctrl = File.readlines(@file)
        idx_one, idx_two = search(ctrl).search_section(point_one, point_two)
        return if idx_one.zero?
        output_format(ctrl, idx_one, idx_two)
      rescue StandardError
        false
      end

      def code_save(input)
        ctrl = File.readlines(@file)
        idx_one, idx_two = search(ctrl).search_section(point_one, point_two)
        return if idx_one.zero?
        ctrl = save_format(ctrl, input, idx_one, idx_two)
        File.write(@file, ctrl)
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

      def update_function(ctrl, idx_one, idx_two, name)
        ctrl[idx_one] = "    # begin callback #{name}\n"
        ctrl[idx_one + 1] = "    def #{name}\n"
        ctrl[idx_two] = "    # end callback #{name}\n"
      end

      def output_format(ctrl, idx_one, idx_two)
        ctrl = ctrl[idx_one + 2..idx_two - 2]
        ctrl = ctrl.map { |line| line[6, line.length] }
        ctrl.join('')
      end

      def save_format(ctrl, input, idx_one, idx_two)
        ctrl.slice!(idx_one + 2..idx_two - 2)
        input.split("\n").each_with_index do |line, i|
          ctrl.insert(idx_one + (i + 2), "      #{line}\n")
        end
        ctrl.join('')
      end
    end
  end
end
