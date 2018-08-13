# frozen_string_literal: true

# HtmlFile Module
module KepplerFrontend
  module Concerns
    module ViewJsFile
      extend ActiveSupport::Concern

      def view_js_code
        html=File.readlines("#{url_front}/app/views/keppler_frontend/app/frontend/#{name}.js.erb")
        html.join
      end

      def install_view_js
        out_file = File.open("#{url_front}/app/views/keppler_frontend/app/frontend/#{name}.js.erb", "w")
        out_file.puts("// #{name} javascript Erb template");
        out_file.close
        true
      end

      def uninstall_view_js
        file = "#{url_front}/app/views/keppler_frontend/app/frontend/#{name}.js.erb"
        File.delete(file) if File.exist?(file)
        true
      end

      def update_view_js(view_js)
        obj = View.find(id)
        old_name = "#{url_front}/app/views/keppler_frontend/app/frontend/#{obj.name}.js.erb"
        new_name = "#{url_front}/app/views/keppler_frontend/app/frontend/#{html[:name]}.js.erb"
        File.rename(old_name, new_name)
      end

      private

      def url_front
        "#{Rails.root}/rockets/keppler_frontend"
      end
    end
  end
end
