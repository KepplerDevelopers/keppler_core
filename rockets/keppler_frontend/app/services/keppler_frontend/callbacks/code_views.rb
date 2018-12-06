# frozen_string_literal: true

module KepplerFrontend
  module Callbacks
    # CodeViews
    class CodeViews
      def initialize(view_data, callback_data)
        @view = view_data
        @callback = callback_data
        @file = front.controller
      end

      def add
        ctrl = File.readlines(@file)
        idx = search(ctrl).search_line(flag_point)
        return unless search_callback(ctrl).zero?
        ctrl.insert(idx.to_i + 1, line_template)
        File.write(@file, ctrl.join(''))
        true
      rescue StandardError
        false
      end

      def remove
        ctrl = File.readlines(@file)
        idx = search_callback(ctrl)
        ctrl.delete_at(idx) unless idx.zero?
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
        '  class App::FrontendController < App::AppController'
      end

      def line_template
        "    #{callback_line}\n"
      end

      def search(html)
        KepplerFrontend::Utils::CodeSearch.new(html)
      end

      def search_callback(ctrl)
        ctrl.include?(line_template) ? ctrl.find_index(line_template) : 0
      end

      def callback_line
        code_lines[@callback.function_type.to_sym]
      end

      def code_lines
        {
          before_action: "before_action :#{@callback.name}, " \
                          "only: [:#{@view.name}]",
          before_filter: "before_filter :#{@callback.name}, " \
                          "only: [:#{@view.name}]",
          after_action: "after_action :#{@callback.name}, " \
                          "only: [:#{@view.name}]",
          after_filter: "after_filter :#{@callback.name}, " \
                          "only: [:#{@view.name}]"
        }
      end
    end
  end
end
