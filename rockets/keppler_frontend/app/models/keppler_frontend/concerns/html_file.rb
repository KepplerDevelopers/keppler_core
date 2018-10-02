# frozen_string_literal: true

# HtmlFile Module
module KepplerFrontend
  module Concerns
    module HtmlFile
      extend ActiveSupport::Concern

      def html_code
        html=File.readlines("#{url_front}/app/views/keppler_frontend/app/frontend/#{name}.html.erb")
        html.join

        file = "#{url_front}/app/views/keppler_frontend/app/frontend/#{name}.html.erb"
        index_html = File.readlines(file)
        begin_idx = 0
        end_idx = 0
        index_html.each do |idx|
          begin_idx = index_html.find_index(idx) if idx.include?("<keppler-view id='#{name}'\n")
          end_idx = index_html.find_index(idx) if idx.include?("</keppler-view>")
        end
        index_html = index_html[begin_idx+1..end_idx-1]
        index_html.join('')
      end

      def install_html
        out_file = File.open("#{url_front}/app/views/keppler_frontend/app/frontend/#{name}.html.erb", "w")
        out_file.puts("<keppler-view id='#{name}'>\n  <h1> #{name} template </h1>\n</keppler-view>");
        out_file.close
        true
      end

      def uninstall_html
        file = "#{url_front}/app/views/keppler_frontend/app/frontend/#{name}.html.erb"
        File.delete(file) if File.exist?(file)
        true
      end

      def update_html(html)
        obj = View.find(id)
        old_name = "#{url_front}/app/views/keppler_frontend/app/frontend/#{obj.name}.html.erb"
        new_name = "#{url_front}/app/views/keppler_frontend/app/frontend/#{html[:name]}.html.erb"
        File.rename(old_name, new_name)
      end

      private

      def url_front
        "#{Rails.root}/rockets/keppler_frontend"
      end
    end
  end
end
