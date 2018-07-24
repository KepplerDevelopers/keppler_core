# View Model
module KepplerFrontend
  class View < ActiveRecord::Base
    include ActivityHistory
    include CloneRecord
    include KepplerFrontend::Concerns::HtmlFile
    include KepplerFrontend::Concerns::ScssFile
    include KepplerFrontend::Concerns::JsFile
    include KepplerFrontend::Concerns::RouteFile
    include KepplerFrontend::Concerns::ActionFile
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
        install_scss
        install_js
      end
      add_route
    end

    def uninstall
      if format_result.eql?('HTML')
        delete_action_html
        uninstall_html
        uninstall_scss
        uninstall_js
      end
      delete_route
    end

    def update_files(params)
      update_html(params) if self.format_result.eql?('HTML')
      update_css(params) if self.format_result.eql?('HTML')
      update_js(params) if self.format_result.eql?('HTML')
      update_action(params)
    end

    def code_save(code, type_code)
      if type_code.eql?('html')
        save_code("#{url_front}/app/views/keppler_frontend/app/frontend/#{name}.html.erb", code)
      elsif type_code.eql?('scss')
        save_code("#{url_front}/app/assets/stylesheets/keppler_frontend/app/#{name}.scss", code)
      elsif type_code.eql?('js')
        save_code("#{url_front}/app/assets/javascripts/keppler_frontend/app/#{name}.js", code)
      elsif type_code.eql?('action')
        save_action(code)
      end
    end

    def save_code(file, code)
      File.delete(file) if File.exist?(file)
      out_file = File.open(file, "w")
      out_file.puts(code)
      out_file.close
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
      self.name.gsub!('/', '')
      self.name.gsub!('.', '')
    end
  end
end
