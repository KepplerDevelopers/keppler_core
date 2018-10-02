# frozen_string_literal: true

# HtmlFile Module
module KepplerFrontend
  module Concerns
    module ScssFile
      extend ActiveSupport::Concern

      def scss_code
        File.read("#{url_front}/app/assets/stylesheets/keppler_frontend/app/views/#{name}.scss")
      end

      def install_scss
        out_file = File.open("#{url_front}/app/assets/stylesheets/keppler_frontend/app/views/#{name}.scss", "w")
        out_file.puts("/* Keppler - #{name}.scss file */");
        out_file.close
        true
      end

      def uninstall_scss
        file = "#{url_front}/app/assets/stylesheets/keppler_frontend/app/views/#{name}.scss"
        File.delete(file) if File.exist?(file)
        true
      end

      def update_css(css)
        obj = View.find(id)
        old_name = "#{url_front}/app/assets/stylesheets/keppler_frontend/app/views/#{obj.name}.scss"
        new_name = "#{url_front}/app/assets/stylesheets/keppler_frontend/app/views/#{css[:name]}.scss"
        File.rename(old_name, new_name)
      end

      private

      def url_front
        "#{Rails.root}/rockets/keppler_frontend"
      end
    end
  end
end
