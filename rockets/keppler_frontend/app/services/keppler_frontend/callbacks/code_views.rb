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

      def change
        ctrl = File.readlines(@file)
        idx = search(ctrl).search_line(flag_point)
        idx_remove = search_callback(ctrl)
        ctrl.delete_at(idx_remove) unless idx_remove.zero?
        ctrl.insert(idx.to_i + 1, line_template)
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
        @actions = ViewCallback.where(name: @callback.name, 
                                      function_type: @callback.function_type)
        @actions = @actions.map { |c| c.view.name.to_sym }
        if @actions.count.zero?
          nil
        else
          "    #{callback_line}, only: #{@actions}\n"
        end
      end

      def search(html)
        KepplerFrontend::Utils::CodeSearch.new(html)
      end

      def search_callback(ctrl)
        idx = 0
        ctrl.each do |line|
          if line.include?(callback_line) 
            idx = ctrl.find_index(line)
          end 
        end
        idx
      end

      def callback_line
        code_lines[@callback.function_type.to_sym]
      end

      def code_lines
        {
          before_action: "before_action :#{@callback.name}",
          before_filter: "before_filter :#{@callback.name}",
          after_action: "after_action :#{@callback.name}",
          after_filter: "after_filter :#{@callback.name }"
        }
      end
    end
  end
end
