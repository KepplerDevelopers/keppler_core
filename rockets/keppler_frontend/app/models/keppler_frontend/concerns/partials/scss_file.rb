# frozen_string_literal: true

# HtmlFile Module
module KepplerFrontend
  module Concerns
    module Partials
      module ScssFile
        extend ActiveSupport::Concern

        def scss_code
          file = "#{url_front}/app/assets/stylesheets/keppler_frontend/app/partials/#{underscore_name}.scss"
          index_html = File.readlines(file)
          begin_idx = 0
          end_idx = 0
          index_html.each do |idx|
            begin_idx = index_html.find_index(idx) if idx.include?("##{name} {\n")
            end_idx = index_html.find_index(idx) if idx.include?("}\n")
          end
          index_html = index_html[begin_idx+1..end_idx-1]
          index_html = index_html.map { |line| line[2, line.length] }
          index_html.join('')
        end

        def install_scss
          file = File.open("#{url_front}/app/assets/stylesheets/keppler_frontend/app/partials/#{underscore_name}.scss", "w")
          index_html = File.readlines(file)
          head_idx = 0
          index_html.insert(head_idx.to_i + 1, "##{name} {\n")
          index_html.insert(head_idx.to_i + 2, "  // Insert scss code...")
          index_html.insert(head_idx.to_i + 3, "\n}\n")
          index_html = index_html.join('')
          File.write(file, index_html)
          file.close
          true
        end

        def uninstall_scss
          file = "#{url_front}/app/assets/stylesheets/keppler_frontend/app/partials/#{underscore_name}.scss"
          File.delete(file) if File.exist?(file)
          true
        end

        def update_css(css)
          obj = Partial.find(id)
          old_name = "#{url_front}/app/assets/stylesheets/keppler_frontend/app/partials/#{obj.underscore_name}.scss"
          new_name = "#{url_front}/app/assets/stylesheets/keppler_frontend/app/partials/#{'_' + css[:name]}.scss"
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
