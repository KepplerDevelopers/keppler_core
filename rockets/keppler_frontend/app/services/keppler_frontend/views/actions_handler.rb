# frozen_string_literal: true

module KepplerFrontend
  module Views
    # CodeHandler
    class ActionsHandler
      def initialize(view_data)
        @view = view_data
      end

      def install
        ctrl = File.readlines(front.controller)
        idx = search(ctrl).search_line(flag_point)
        ctrl = add_action(ctrl, idx)
        File.write(front.controller, ctrl)
        true
      rescue StandardError
        false
      end

      def uninstall
        ctrl = File.readlines(front.controller)
        idx_one, idx_two = search(ctrl).search_section(point_one, point_two)
        return if idx_one.zero?
        ctrl.slice!(idx_one..idx_two)
        ctrl = ctrl.join('')
        File.write(front.controller, ctrl)
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
