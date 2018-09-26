module KepplerFrontend
  module Concerns
    # Concern con la configuracion de parametros de los formulario
    module Grapesjs
      extend ActiveSupport::Concern

      included do
      end

      private

      def url_front
        "#{Rails.root}/rockets/keppler_frontend"
      end

      def index_section(html_lines, point_1, point_2)
        begin_idx = 0
        end_idx = 0
        html_lines.each do |line|
          begin_idx = html_lines.find_index(line) if line.include?(point_1.gsub("'", "\""))
        end
        html_lines[begin_idx..html_lines.size].each do |line|
          if line.include?(point_2)
            end_idx = begin_idx + html_lines[begin_idx..html_lines.size].find_index(line) 
          end
        end
        [begin_idx, end_idx]
      end

      def index_empty_section(html_lines, point)
        begin_idx = 0
        html_lines.each do |line|
          begin_idx = html_lines.find_index(line) if line.include?(point)
        end
        begin_idx
      end

      def grapes_info      
        if params[:editor] && controller_name.eql?('frontend') && !action_name.eql?('keppler')
          gon.view_id = params[:view]
          gon.css_style = set_css_style
          gon.images_assets = set_assets
          gon.components = set_components
        end
      end
  
      def set_css_style
        lines = File.readlines("#{url_front}/app/assets/stylesheets/keppler_frontend/app/views/#{action_name}.scss")
        lines = lines.select { |l| !l.include?("//") }
        lines.join
      end
  
      def set_assets
        images = Dir["#{url_front}/app/assets/images/keppler_frontend/app/*"]
        images_containers = []
        images.each do |image|
          images_containers << { type: 'image', src: "/assets/keppler_frontend/app/#{image.split('/').last}" }
        end
        return images_containers
      end
  
      def set_components
        list_components = []
        components = Dir["#{url_front}/app/assets/html/keppler_frontend/app/**/*.html"]
        components.each do |component|
          lines = File.readlines(component)
          begin_idx = 0
          end_idx = 0
          lines.each do |idx|
            begin_idx = lines.find_index(idx) if idx.include?("<script>")
            end_idx = lines.find_index(idx) if idx.include?("</script>")
          end
          lines = lines[begin_idx+1..end_idx-1]
          list_components << ["[#{lines.join('')}]".gsub!("\n", ""), set_content(component)]
        end
        list_components
      end
  
      def set_content(component)
        lines = File.readlines(component)
        begin_idx = 0
        end_idx = 0
        lines.each do |idx|
          begin_idx = lines.find_index(idx) if idx.include?("<keppler-component>")
          end_idx = lines.find_index(idx) if idx.include?("</keppler-component>")
        end
        lines[begin_idx+1..end_idx-1].join('')
      end  

      def save_grapesjs_code(view_id, html, css)
        view = KepplerFrontend::View.find(view_id)
        save_css(view.name, css)
        save_html(view.name, html)
        'Your code has been saved'
      end

      def save_css(view_name, css)
        file = "#{url_front}/app/assets/stylesheets/keppler_frontend/app/views/#{view_name}.scss"
        File.delete(file) if File.exist?(file)
        out_file = File.open(file, "w")
        out_file.puts(css)
        out_file.close
      end

      def save_html(view_name, editor)
        origin_view = "#{url_front}/app/views/keppler_frontend/app/frontend/#{view_name}.html.erb"
        origin_layout = "#{url_front}/app/views/layouts/keppler_frontend/app/layouts/application.html.erb"
        save_section('keppler-header', editor, origin_layout)
        save_section('keppler-view', view_name, editor, origin_view)
        save_section('keppler-footer', editor, origin_layout)
        # lines = File.readlines("#{url_front}/app/views/keppler_frontend/app/frontend/#{view_name}.html.erb")
      end

      def save_section(section, view_name='', editor, origin)
        origin_lines = File.readlines(origin)
        ##### Fusion entre el codigo de origin y el codigo del editor
        editor_lines = editor.split("\n")       
        section_label = view_name.eql?('') ? "<#{section}" : "<#{section} id='#{view_name}'"
        idx_section = index_section(editor_lines, section_label, "</#{section}>")
        editor_lines = editor_lines[idx_section[0]..idx_section[1]] 
        ids = ids_no_edit(editor_lines.join)
        codes_no_edit = code_no_edit(ids, origin_lines)
        code = merge_to_editor(editor_lines, codes_no_edit)
        ##### Sustituir codigo de origen con el codigo fusionado
        origin_section = index_section(origin_lines, "<#{section}>", "</#{section}>")
        origin_lines.slice!(origin_section[0]+1..origin_section[1]-1)
        code[1..code.length-2].reverse.each_with_index do |line, i|
          origin_lines.insert(origin_section[0]+1, "#{line}\n")
        end
        origin_lines.insert(origin_section[0]+1, "<!-- Keppler Section -->\n")        
        File.write(origin, HtmlBeautifier.beautify(origin_lines.join('')))
      end

      def ids_no_edit(section)
        doc = Nokogiri::HTML(section)
        nodes = []
        doc.css('keppler-no-edit').each do |link|
          nodes << [link.attribute("id").value]
        end
        nodes
      end 
      
      def code_no_edit(ids, origin)       
        ids.each_with_index do |id, idx|
          idx_section = index_section(origin, "<keppler-no-edit id='#{id.first}'", "</keppler-no-edit>")   
          ids[idx] << origin[ idx_section[0]..idx_section[1] ] 
        end        
      end

      def merge_to_editor(editor_lines, codes_no_edit)
        codes_no_edit.each do |code|
          idx_empty = index_empty_section(editor_lines, "<keppler-no-edit id=\"#{code.first}\"></keppler-no-edit>") 
          if !idx_empty.zero?
            editor_lines.slice!(idx_empty)
          else
            idx_section = index_section(editor_lines, "<keppler-no-edit id=\"#{code.first}\"", "</keppler-no-edit>") 
            editor_lines.slice!(idx_section[0]+1..idx_section[1]-1)
            code.last[1..code.last.length-2].reverse.each_with_index do |line, i|
              editor_lines.insert(idx_section[0]+1, "#{line}\n")
            end
          end
        end
        editor_lines
      end
    end
  end
end