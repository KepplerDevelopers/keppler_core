# frozen_string_literal: true

# ActionsOnDatabase Module
module KepplerFrontend
  module Concerns
    module CallbackActions
      extend ActiveSupport::Concern


      def url_front
        "#{Rails.root}/rockets/keppler_frontend"
      end

      def add_callback_to(callback)
        file = "#{url_front}/app/controllers/keppler_frontend/app/frontend_controller.rb"
        code = File.readlines(file)
        head_idx = 0
        code.each do |i|
          head_idx = code.find_index(i) if i.include?("    # Begin callbacks area (don't delete)")
        end
        if search_callback_line(callback) == 0
          code.insert(head_idx.to_i + 1, "    #{callback_line(callback)}\n")
        end
        code = code.join('')
        File.write(file, code)
      end

      #[:belongs_to, :has_one, :has_many, :has_and_belongs_to_many]
      def callback_line(callback)
        callback_list = {
          :before_action => "before_action :#{callback[:name]}",
          :before_filter => "before_filter :#{callback[:name]}",
          :after_action => "after_action :#{callback[:name]}",
          :after_filter => "after_filter :#{callback[:name]}"
        }
        callback_list[callback[:function_type].to_sym]
      end

      def search_callback_line(callback)
        file = "#{url_front}/app/controllers/keppler_frontend/app/frontend_controller.rb"
        code = File.readlines(file)
        line = "    #{callback_line(callback)}\n"
        result = code.include?(line) ? code.find_index(line) : 0
      end

      def delete_callback(callback)
        file = "#{url_front}/app/controllers/keppler_frontend/app/frontend_controller.rb"
        callback_index = search_callback_line(callback)
        code = File.readlines(file)
        if callback_index > 0
          code.delete_at(callback_index)
        end
        code = code.join('')
        File.write(file, code)
      end
    end
  end
end
