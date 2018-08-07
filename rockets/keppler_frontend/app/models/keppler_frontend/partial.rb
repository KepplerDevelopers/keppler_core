# Partial Model
module KepplerFrontend
  class Partial < ActiveRecord::Base
    include ActivityHistory
    include CloneRecord
    require 'csv'
    acts_as_list
    validates_presence_of :name
    validates_uniqueness_of :name
    before_save :convert_to_downcase, :without_spaces

    include KepplerFrontend::Concerns::Partials::HtmlFile
    include KepplerFrontend::Concerns::Partials::ScssFile
    include KepplerFrontend::Concerns::Partials::JsFile

    def underscore_name
      '_' + name.split(' ').join('_').downcase
    end

    # Fields for the search form in the navbar
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

    def without_spaces
      self.name.gsub!(' ', '_')
      self.name.gsub!('/', '')
      self.name.gsub!('.', '')
    end

    def install
      install_html
      install_scss
      install_js
    end

    def uninstall
      uninstall_html
      uninstall_scss
      uninstall_js
    end
    private

    def url_front
      "#{Rails.root}/rockets/keppler_frontend"
    end
  end
end
