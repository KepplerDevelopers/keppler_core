# frozen_string_literal: true

# HtmlFile Module
module KepplerFrontend
  module Concerns
    module Partials
      module HtmlFile
        extend ActiveSupport::Concern
        def html_code
          file = "#{url_front}/app/views/keppler_frontend/app/partials/#{underscore_name}.html.erb"
          index_html = File.readlines(file)
          begin_idx = 0
          end_idx = 0
          index_html.each do |idx|
            begin_idx = index_html.find_index(idx) if idx.include?("<keppler-partial id='#{name}'>\n")
            end_idx = index_html.find_index(idx) if idx.include?("</keppler-partial>\n")
          end
          # return if begin_idx==0
          index_html = index_html[begin_idx+1..end_idx-1]
          index_html = index_html.map { |line| line[0, line.length] }
          index_html.join('')
        end

        def install_html
          file = File.open("#{url_front}/app/views/keppler_frontend/app/partials/#{underscore_name}.html.erb", "w")
          index_html = File.readlines(file)
          head_idx = 0
          index_html.insert(head_idx.to_i + 1, "<keppler-partial id='#{name}'>\n")
          index_html.insert(head_idx.to_i + 2, "  <h1> #{name} partial </h1>")
          index_html.insert(head_idx.to_i + 3, "\n</keppler-partial>\n")
          index_html = index_html.join('')
          File.write(file, index_html)
          file.close
          true
        end

        def uninstall_html
          file = "#{url_front}/app/views/keppler_frontend/app/partials/#{underscore_name}.html.erb"
          File.delete(file) if File.exist?(file)
          true
        end

        def update_html(html)
          file = "#{url_front}/app/views/keppler_frontend/app/partials/#{underscore_name}.html.erb"
          index_html = File.readlines(file)
          begin_idx = 0
          end_idx = 0
          default_idx = 0
          index_html.each do |idx|
            begin_idx = index_html.find_index(idx) if idx.include?("<keppler-partial id='#{name}'>\n")
            end_idx = index_html.find_index(idx) if idx.include?("</keppler-partial>\n")
            default_idx = index_html.find_index(idx) if idx.include?("  <h1> #{name} partial </h1>")
          end
          index_html[begin_idx] = "<keppler-partial id='#{html[:name]}'>\n"
          index_html[end_idx] = "</keppler-partial>"
          index_html[default_idx] = "  <h1> #{html[:name]} partial </h1>\n" unless default_idx.eql?(0)
          index_html = index_html.join('')
          File.write(file, index_html)
          # file.close
          true

          obj = Partial.find(id)
          old_name = "#{url_front}/app/views/keppler_frontend/app/partials/#{obj.underscore_name}.html.erb"
          new_name = "#{url_front}/app/views/keppler_frontend/app/partials/#{'_' + html[:name]}.html.erb"
          File.rename(old_name, new_name)
        end

        def save_html(code)
          file = "#{url_front}/app/views/keppler_frontend/app/partials/#{underscore_name}.html.erb"
          code_html = File.readlines(file)
          begin_idx = 0
          end_idx = 0
          code_html.each do |i|
            begin_idx = code_html.find_index(i) if i.include?("<keppler-partial id='#{name}'>\n")
            end_idx = code_html.find_index(i) if i.include?("</keppler-partial>\n")
          end
          # return if begin_idx==0
          code_html.slice!(begin_idx+1..end_idx-1)
          code.split("\n").each_with_index do |line, i|
            code_html.insert(begin_idx+(i+1), "#{line}\n")
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
end
