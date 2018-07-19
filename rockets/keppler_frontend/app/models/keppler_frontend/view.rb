# View Model
module KepplerFrontend
  class View < ActiveRecord::Base
    include ActivityHistory
    include CloneRecord
    require 'csv'
    acts_as_list
    validates_presence_of :name, :url
    validates_uniqueness_of :name, :url
    before_validation :convert_to_downcase, :without_spaces

    # Fields for the search form in the navbar
    def self.search_field
      fields = ['name', 'url', 'method', 'format_result']
      build_query(fields, :or, :cont)
    end

    def self.upload(file)
      CSV.foreach(file.path, headers: true) do |row|
        begin
          self.create! row.to_hash
        rescue => err
        end
      end
    end

    def self.sorter(params)
      params.each_with_index do |id, idx|
        self.find(id).update(position: idx.to_i+1)
      end
    end

    # Funcion para armar el query de ransack
    def self.build_query(fields, operator, conf)
      query = fields.join("_#{operator}_")
      query << "_#{conf}"
      query.to_sym
    end

    def color
      return 'olive' if ['GET', 'POST'].include?(method)
      return 'blue' if ['ROOT'].include?(method)
      return 'orange' if ['PATCH', 'PUT'].include?(method)
      return 'red' if ['DELETE'].include?(method)
    end

    def path
      "#{name}_path"
    end

    def install
      if format_result.eql?('HTML')
        create_action_html
        install_html
      end
      add_route
    end

    def uninstall
      if format_result.eql?('HTML')
        delete_action_html
        uninstall_html
      end
      delete_route
    end

    def create_action_html
      file = "#{url_front}/app/controllers/keppler_frontend/app/frontend_controller.rb"
      index_html = File.readlines(file)
      head_idx = 0
      index_html.each do |i|
        head_idx = index_html.find_index(i) if i.include?("    layout 'layouts/templates/application'")
      end
      index_html.insert(head_idx.to_i + 1, "    # begin #{name}\n")
      index_html.insert(head_idx.to_i + 2, "    def #{name}\n")
      index_html.insert(head_idx.to_i + 3, "    end\n")
      index_html.insert(head_idx.to_i + 4, "    # end #{name}\n")
      index_html = index_html.join('')
      File.write(file, index_html)
      true
    end

    def delete_action_html
      file = "#{url_front}/app/controllers/keppler_frontend/app/frontend_controller.rb"
      index_html = File.readlines(file)
      begin_idx = 0
      end_idx = 0
      index_html.each do |i|
        begin_idx = index_html.find_index(i) if i.include?("    # begin #{name}\n")
        end_idx = index_html.find_index(i) if i.include?("    # end #{name}\n")
      end
      return if begin_idx==0
      index_html.slice!(begin_idx..end_idx)
      index_html = index_html.join('')
      File.write(file, index_html)
      true
    end

    def update_action(action)
      obj = View.find(id)
      file = "#{url_front}/app/controllers/keppler_frontend/app/frontend_controller.rb"
      index_html = File.readlines(file)
      begin_idx = 0
      end_idx = 0
      index_html.each do |i|
        begin_idx = index_html.find_index(i) if i.include?("    # begin #{obj.name}\n")
        end_idx = index_html.find_index(i) if i.include?("    # end #{obj.name}\n")
      end
      return if begin_idx==0
      index_html[begin_idx] = "    # begin #{action[:name]}\n"
      index_html[begin_idx+1] = "    def #{action[:name]}\n"
      index_html[end_idx] = "    # end #{action[:name]}\n"
      index_html = index_html.join('')
      File.write(file, index_html)
      true
    end

    def install_html
      out_file = File.open("#{url_front}/app/views/keppler_frontend/app/frontend/#{name}.html.erb", "w")
      html = ["<!DOCTYPE html>\n", "<html>\n", "  <head>\n",
              "    <meta charset='utf-8'>\n", "    <title></title>\n",
              "    <link rel='stylesheet' href='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css'>\n",
              "    <script src='https://code.jquery.com/jquery-2.2.4.min.js'></script>\n",
              "    <script src='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js'></script>\n",
              "  </head>\n", "  <body>\n", "    <h1> #{name} template </h1>\n",
              "  </body>\n", "</html>\n"]
      hteml = html.join('')
      out_file.puts(html);
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

    def add_route
      file = "#{url_front}/config/routes.rb"
      index_html = File.readlines(file)
      head_idx = 0
      index_html.each do |i|
        head_idx = index_html.find_index(i) if i.include?('KepplerFrontend::Engine.routes.draw do')
      end
      if active.eql?(false)
        index_html.insert(head_idx.to_i + 1, "#  #{method.downcase!} '#{url}', to: 'app/frontend##{name}', as: :#{name}\n")
      else
        index_html.insert(head_idx.to_i + 1, "  #{method.downcase!} '#{url}', to: 'app/frontend##{name}', as: :#{name}\n")
      end
      index_html = index_html.join('')
      File.write(file, index_html)
      true
    end

    def delete_route
      file = "#{url_front}/config/routes.rb"
      index_html = File.readlines(file)
      head_idx = 0
      index_html.each do |idx|
        if active.eql?(false)
          head_idx = index_html.find_index(idx) if idx.include?("#  #{method.downcase} '#{url}', to: 'app/frontend##{name}', as: :#{name}\n")
        else
          head_idx = index_html.find_index(idx) if idx.include?("  #{method.downcase} '#{url}', to: 'app/frontend##{name}', as: :#{name}\n")
        end
      end
      return if head_idx==0
      index_html.delete_at(head_idx.to_i)
      index_html = index_html.join('')
      File.write(file, index_html)
      true
    end

    def html_code
      index_html = File.readlines("#{url_front}/app/views/keppler_frontend/app/frontend/#{name}.html.erb")
      index_html.map { |idx| idx.gsub('"', "'") }
      index_html = index_html.join('')
    end

    def code_save(code, type_code)
      if type_code.eql?('html')
        out_file = File.open("#{url_front}/app/views/keppler_frontend/app/frontend/#{name}.html.erb", "w")
        out_file.puts(code)
        out_file.close
      end
    end

    private

    def url_front
      "#{Rails.root}/rockets/keppler_frontend"
    end

    def convert_to_downcase
      self.url.downcase!
      self.name.downcase!
    end

    def without_spaces
      self.url.gsub!(' ', '_')
      self.name.gsub!(' ', '_')
    end
  end
end
