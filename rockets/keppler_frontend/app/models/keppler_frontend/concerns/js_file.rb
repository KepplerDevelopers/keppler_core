# frozen_string_literal: true

# HtmlFile Module
module KepplerFrontend
  module Concerns
    module JsFile
      extend ActiveSupport::Concern

      def js_code
        File.read("#{url_front}/app/assets/javascripts/keppler_frontend/app/views/#{name}.js")
      end

      def install_js
        out_file = File.open("#{url_front}/app/assets/javascripts/keppler_frontend/app/views/#{name}.js", "w")
        out_file.puts("// Keppler - #{name}.js file\n$(document).ready(function(){\n  // Use jquery functions here\n});");
        out_file.close
        true
      end

      def uninstall_js
        file = "#{url_front}/app/assets/javascripts/keppler_frontend/app/views/#{name}.js"
        File.delete(file) if File.exist?(file)
        true
      end

      def update_js(css)
        obj = View.find(id)
        old_name = "#{url_front}/app/assets/javascripts/keppler_frontend/app/views/#{obj.name}.js"
        new_name = "#{url_front}/app/assets/javascripts/keppler_frontend/app/views/#{css[:name]}.js"
        File.rename(old_name, new_name)
      end

      private

      def url_front
        "#{Rails.root}/rockets/keppler_frontend"
      end
    end
  end
end
