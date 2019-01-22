# frozen_string_literal: true

module KepplerFrontend
  module Views
    # CodeHandler
    class ActionsHandler
      def initialize(view_data)
        @view = view_data
        @file = front.controller
      end

      def install
        ctrl = File.readlines(@file)
        idx = search(ctrl).search_line(flag_point)
        ctrl = add_action(ctrl, idx)
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
        ctrl = ctrl.join('')
        File.write(@file, ctrl)
        true
      rescue StandardError
        false
      end

      def update(name)
        ctrl = File.readlines(@file)
        idx_one, idx_two = search(ctrl).search_section(point_one, point_two)
        return if idx_one.zero?
        ctrl = update_name(ctrl, idx_one, idx_two, name)
        File.write(@file, ctrl)
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

      def save(input)
        ctrl = File.readlines(@file)
        idx_one, idx_two = search(ctrl).search_section(point_one, point_two)
        return if idx_one.zero?
        ctrl = save_format(ctrl, input, idx_one, idx_two)
        File.write(@file, ctrl)
        true
      rescue StandardError
        false
      end

      private

      def front
        KepplerFrontend::Urls::Front.new
      end

      def flag_point
        "    layout 'layouts/keppler_frontend/app/layouts/application'"
      end

      def point_one
        "    # begin #{@view.name}\n"
      end

      def point_two
        "    # end #{@view.name}\n"
      end

      def search(html)
        KepplerFrontend::Utils::CodeSearch.new(html)
      end

      def save_format(ctrl, input, idx_one, idx_two)
        ctrl.slice!(idx_one + 2..idx_two - 2)
        input.split("\n").each_with_index do |line, i|
          ctrl.insert(idx_one + (i + 2), "      #{line}\n")
        end
        ctrl.join('')
      end

      def output_format(ctrl, idx_one, idx_two)
        action = ctrl[idx_one + 2..idx_two - 2]
        action = action.map { |line| line[6, line.length] }
        action.join('')
      end

      def update_name(ctrl, idx_one, idx_two, name)
        ctrl[idx_one] = "    # begin #{name}\n"
        ctrl[idx_one + 1] = "    def #{name}\n"
        ctrl[idx_two] = "    # end #{name}\n"
        ctrl.join('')
      end

      def add_action(controller, idx)
        idx = idx.to_i
        name = @view.name
        controller.insert(idx + 1, "    # begin #{name}\n")
        controller.insert(idx + 2, "    def #{name}\n")
        controller.insert(idx + 3, "      # Insert ruby code...\n")
        controller.insert(idx + 4, "    end\n")
        controller.insert(idx + 5, "    # end #{name}\n")
        controller.join('')
      end
    end
  end
end
