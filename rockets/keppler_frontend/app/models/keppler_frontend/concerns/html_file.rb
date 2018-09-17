# frozen_string_literal: true

# HtmlFile Module
module KepplerFrontend
  module Concerns
    module HtmlFile
      extend ActiveSupport::Concern

      def html_code
        html=File.readlines("#{url_front}/app/views/keppler_frontend/app/frontend/#{name}.html.erb")
        html.join
      end

      def install_html
        out_file = File.open("#{url_front}/app/views/keppler_frontend/app/frontend/#{name}.html.erb", "w")
        out_file.puts("<keppler-#{name}>\n  <h1> #{name} template </h1>\n</keppler-#{name}>");
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
