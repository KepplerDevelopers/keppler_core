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
          begin_idx = index_html.find_index(idx) if idx.include?("<head>")
          end_idx = index_html.find_index(idx) if idx.include?("</head")
        end
        index_html = index_html[begin_idx+1..end_idx-1]
        index_html = index_html.map { |line| line[0, line.length] }
        index_html.join('')
      end

      def keppler_header_code
        file = "#{url_front}/app/views/layouts/keppler_frontend/app/layouts/application.html.erb"
        index_html = File.readlines(file)
        begin_idx = 0
        end_idx = 0
        index_html.each do |idx|
          begin_idx = index_html.find_index(idx) if idx.include?("<keppler-header>")
          end_idx = index_html.find_index(idx) if idx.include?("</keppler-header>")
        end
        index_html = index_html[begin_idx+1..end_idx-1]
        index_html = index_html.map { |line| line[0, line.length] }
        index_html.join('')
      end

      def keppler_footer_code
        file = "#{url_front}/app/views/layouts/keppler_frontend/app/layouts/application.html.erb"
        index_html = File.readlines(file)
        begin_idx = 0
        end_idx = 0
        index_html.each do |idx|
          begin_idx = index_html.find_index(idx) if idx.include?("<keppler-footer>")
          end_idx = index_html.find_index(idx) if idx.include?("</keppler-footer>")
        end
        index_html = index_html[begin_idx+1..end_idx-1]
        index_html = index_html.map { |line| line[0, line.length] }
        index_html.join('')
      end

      def save_head(code)
        file = "#{url_front}/app/views/layouts/keppler_frontend/app/layouts/application.html.erb"
        code_html = File.readlines(file)
        begin_idx = 0
        end_idx = 0
        code_html.each do |i|
          begin_idx = code_html.find_index(i) if i.include?("<head>")
          end_idx = code_html.find_index(i) if i.include?("</head>")
        end

        code_html.slice!(begin_idx+1..end_idx-1)
        code.split("\n").each_with_index do |line, i|
          code_html.insert(begin_idx+(i+1), "    #{line}\n")
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
          begin_idx = code_html.find_index(i) if i.include?("<keppler-header>")
          end_idx = code_html.find_index(i) if i.include?("</keppler-header>")
        end

        code_html.slice!(begin_idx+1..end_idx-1)
        code.split("\n").each_with_index do |line, i|
          code_html.insert(begin_idx+(i+1), "      #{line}\n")
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
          begin_idx = code_html.find_index(i) if i.include?("<keppler-footer>")
          end_idx = code_html.find_index(i) if i.include?("</keppler-footer>")
        end

        code_html.slice!(begin_idx+1..end_idx-1)
        code.split("\n").each_with_index do |line, i|
          code_html.insert(begin_idx+(i+1), "      #{line}\n")
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
