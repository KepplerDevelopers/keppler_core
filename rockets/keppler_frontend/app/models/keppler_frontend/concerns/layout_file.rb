# frozen_string_literal: true

# HtmlFile Module
module KepplerFrontend
  module Concerns
    module LayoutFile
      extend ActiveSupport::Concern

      def head_code
        file = "#{url_front}/app/views/layouts/keppler_frontend/app/layouts/application.html.erb"
        index_html = File.readlines(file)
        begin_idx = 0
        end_idx = 0
        index_html.each do |idx|
          begin_idx = index_html.find_index(idx) if idx.include?("<!-- begin head -->")
          end_idx = index_html.find_index(idx) if idx.include?("<!-- end head -->")
        end
        index_html = index_html[begin_idx+2..end_idx-2]
        index_html = index_html.map { |line| line[0, line.length] }
        index_html.join('')
      end

      def keppler_footer_code
        file = "#{url_front}/app/views/layouts/keppler_frontend/app/layouts/application.html.erb"
        index_html = File.readlines(file)
        begin_idx = 0
        end_idx = 0
        index_html.each do |idx|
          begin_idx = index_html.find_index(idx) if idx.include?("<!-- begin keppler-footer -->")
          end_idx = index_html.find_index(idx) if idx.include?("<!-- end keppler-footer -->")
        end
        index_html = index_html[begin_idx+2..end_idx-2]
        index_html = index_html.map { |line| line[0, line.length] }
        index_html.join('')
      end

      def keppler_header_code
        file = "#{url_front}/app/views/layouts/keppler_frontend/app/layouts/application.html.erb"
        index_html = File.readlines(file)
        begin_idx = 0
        end_idx = 0
        index_html.each do |idx|
          begin_idx = index_html.find_index(idx) if idx.include?("<!-- begin keppler-header -->")
          end_idx = index_html.find_index(idx) if idx.include?("<!-- end keppler-header -->")
        end
        index_html = index_html[begin_idx+2..end_idx-2]
        index_html = index_html.map { |line| line[0, line.length] }
        index_html.join('')
      end

      def save_head(code)
        file = "#{url_front}/app/views/layouts/keppler_frontend/app/layouts/application.html.erb"
        code_html = File.readlines(file)
        begin_idx = 0
        end_idx = 0
        code_html.each do |i|
          begin_idx = code_html.find_index(i) if i.include?("<!-- begin head -->\n")
          end_idx = code_html.find_index(i) if i.include?("<!-- end head -->\n")
        end

        code_html.slice!(begin_idx+2..end_idx-2)
        code.split("\n").each_with_index do |line, i|
          code_html.insert(begin_idx+(i+2), "    #{line}\n")
        end
        code_html = code_html.join('')
        File.write(file, code_html)
        true
      end

      def save_header(code)
        file = "#{url_front}/app/views/layouts/keppler_frontend/app/layouts/application.html.erb"
        code_html = File.readlines(file)
        begin_idx = 0
        end_idx = 0
        code_html.each do |i|
          begin_idx = code_html.find_index(i) if i.include?("<!-- begin keppler-header -->\n")
          end_idx = code_html.find_index(i) if i.include?("<!-- end keppler-header -->\n")
        end

        code_html.slice!(begin_idx+2..end_idx-2)
        code.split("\n").each_with_index do |line, i|
          code_html.insert(begin_idx+(i+2), "      #{line}\n")
        end
        code_html = code_html.join('')
        File.write(file, code_html)
        true
      end

      def save_footer(code)
        file = "#{url_front}/app/views/layouts/keppler_frontend/app/layouts/application.html.erb"
        code_html = File.readlines(file)
        begin_idx = 0
        end_idx = 0
        code_html.each do |i|
          begin_idx = code_html.find_index(i) if i.include?("<!-- begin keppler-footer -->\n")
          end_idx = code_html.find_index(i) if i.include?("<!-- end keppler-footer -->\n")
        end

        code_html.slice!(begin_idx+2..end_idx-2)
        code.split("\n").each_with_index do |line, i|
          code_html.insert(begin_idx+(i+2), "      #{line}\n")
        end
        code_html = code_html.join('')
        File.write(file, code_html)
        true
      end

      private

      def url_front
        "#{Rails.root}/rockets/keppler_frontend"
      end
    end
  end
end
