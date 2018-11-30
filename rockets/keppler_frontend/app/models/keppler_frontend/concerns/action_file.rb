# frozen_string_literal: true

# HtmlFile Module
module KepplerFrontend
  module Concerns
    module ActionFile
      extend ActiveSupport::Concerns
      
      def save_action(code)
        file = "#{url_front}/app/controllers/keppler_frontend/app/frontend_controller.rb"
        code_ruby = File.readlines(file)
        begin_idx = 0
        end_idx = 0
        code_ruby.each do |i|
          begin_idx = code_ruby.find_index(i) if i.include?("    # begin #{name}\n")
          end_idx = code_ruby.find_index(i) if i.include?("    # end #{name}\n")
        end
        return if begin_idx==0
        code_ruby.slice!(begin_idx+2..end_idx-2)
        code.split("\n").each_with_index do |line, i|
          code_ruby.insert(begin_idx+(i+2), "      #{line}\n")
        end
        code_ruby = code_ruby.join('')
        File.write(file, code_ruby)
        true
      end

      private

      def url_front
        "#{Rails.root}/rockets/keppler_frontend"
      end
    end
  end
end
