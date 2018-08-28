# Partial Model
module KepplerFrontend
  class Partial < ActiveRecord::Base
    include ActivityHistory
    include CloneRecord
    require 'csv'
    acts_as_list
    validates_presence_of :name
    validates_uniqueness_of :name
    before_save :convert_to_downcase, :without_special_characters
    before_destroy :uninstall

    include KepplerFrontend::Concerns::Partials::HtmlFile
    include KepplerFrontend::Concerns::Partials::ScssFile
    include KepplerFrontend::Concerns::Partials::JsFile
    include KepplerFrontend::Concerns::Partials::HelperFile
    include KepplerFrontend::Concerns::StringActions

    def underscore_name
      '_' + name.split(' ').join('_').downcase
    end

    def self.search_field
      fields = ["name", "position", "deleted_at"]
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

    def convert_to_downcase
      self.name.downcase!
    end

    def without_special_characters
      self.name = self.name.split('').select { |x| x if not_special_chars.include?(x) } .join
    end

    def install
      install_html
      install_scss
      install_js
      create_helper
    end

    def uninstall
      uninstall_html
      uninstall_scss
      uninstall_js
      delete_helper
    end

    def update_files(params)
      update_html(params)
      update_css(params)
      update_js(params)
      update_helper(params)
    end

    def code_save(code, type_code)
      if type_code.eql?('html')
        save_html(code)
      elsif type_code.eql?('scss')
        save_css(code)
      elsif type_code.eql?('js')
        save_code("#{url_front}/app/assets/javascripts/keppler_frontend/app/partials/#{name}.js", code)
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
  end
end
