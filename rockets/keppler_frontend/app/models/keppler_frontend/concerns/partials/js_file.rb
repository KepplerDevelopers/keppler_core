# frozen_string_literal: true

# HtmlFile Module
module KepplerFrontend
  module Concerns
    module Partials
      module JsFile
        extend ActiveSupport::Concern

        def js_code
          File.read("#{url_front}/app/assets/javascripts/keppler_frontend/app/partials/#{name}.js")
        end

        def install_js
          out_file = File.open("#{url_front}/app/assets/javascripts/keppler_frontend/app/partials/#{name}.js", "w")
          out_file.puts("// Insert js code here...");
          out_file.close
          true
        end

        def uninstall_js
          file = "#{url_front}/app/assets/javascripts/keppler_frontend/app/partials/#{name}.js"
          File.delete(file) if File.exist?(file)
          true
        end

        def update_js(js)
          obj = Partial.find(id)
          old_name = "#{url_front}/app/assets/javascripts/keppler_frontend/app/partials/#{obj.name}.js"
          new_name = "#{url_front}/app/assets/javascripts/keppler_frontend/app/partials/#{js[:name]}.js"
          File.rename(old_name, new_name)
        end

        private

        def url_front
          "#{Rails.root}/rockets/keppler_frontend"
        end
      end
    end
  end
end
