# frozen_string_literal: true

# HtmlFile Module
module KepplerFrontend
  module Concerns
    module Partials
      module ScssFile
        extend ActiveSupport::Concern

        def install_scss
          file = File.open("#{url_front}/app/assets/stylesheets/keppler_frontend/app/partials/#{underscore_name}.scss", "w")
          index_html = File.readlines(file)
          head_idx = 0
          index_html.insert(head_idx.to_i + 1, "// begin #{name}\n")
          index_html.insert(head_idx.to_i + 2, "##{name} {\n")
          index_html.insert(head_idx.to_i + 3, "  // Insert scss code...")
          index_html.insert(head_idx.to_i + 4, "\n}\n")
          index_html.insert(head_idx.to_i + 5, "// end #{name}\n")
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

        def scss_code
          # html = File.readlines("#{url_front}/app/assets/stylesheets/keppler_frontend/app/partials/#{underscore_name}.scss")
          # html.join
          file = "#{url_front}/app/assets/stylesheets/keppler_frontend/app/partials/#{underscore_name}.scss"
          index_html = File.readlines(file)
          begin_idx = 0
          end_idx = 0
          index_html.each do |idx|
            begin_idx = index_html.find_index(idx) if idx.include?("// begin #{name}\n")
            end_idx = index_html.find_index(idx) if idx.include?("// end #{name}\n")
          end
          # return if begin_idx==0
          index_html = index_html[begin_idx+2..end_idx-2]
          index_html = index_html.map { |line| line[0, line.length] }
          index_html.join('')
        end

        def update_css(css)
          file = "#{url_front}/app/assets/stylesheets/keppler_frontend/app/partials/#{underscore_name}.scss"
          index_html = File.readlines(file)
          begin_idx = 0
          end_idx = 0
          index_html.each do |idx|
            begin_idx = index_html.find_index(idx) if idx.include?("// begin #{name}\n")
            end_idx = index_html.find_index(idx) if idx.include?("// end #{name}\n")
          end
          index_html[begin_idx] = "// begin #{css[:name]}\n"
          index_html[begin_idx+1] = "##{css[:name]} {\n"
          index_html[end_idx] = "// end #{css[:name]}\n"
          index_html = index_html.join('')
          File.write(file, index_html)

          obj = Partial.find(id)
          old_name = "#{url_front}/app/assets/stylesheets/keppler_frontend/app/partials/#{obj.underscore_name}.scss"
          new_name = "#{url_front}/app/assets/stylesheets/keppler_frontend/app/partials/#{'_' + css[:name]}.scss"
          File.rename(old_name, new_name)
        end

        def save_css(code)
          file = "#{url_front}/app/assets/stylesheets/keppler_frontend/app/partials/#{underscore_name}.scss"
          code_css = File.readlines(file)
          begin_idx = 0
          end_idx = 0
          code_css.each do |i|
            begin_idx = code_css.find_index(i) if i.include?("// begin #{name}\n")
            end_idx = code_css.find_index(i) if i.include?("// end #{name}\n")
          end
          # return if begin_idx==0
          code_css.slice!(begin_idx+2..end_idx-2)
          code.split("\n").each_with_index do |line, i|
            code_css.insert(begin_idx+(i+2), "#{line}\n")
          end
          code_css = code_css.join('')
          File.write(file, code_css)
          true
        end

        private

        def url_front
          "#{Rails.root}/rockets/keppler_frontend"
        end
      end
    end
  end
end
