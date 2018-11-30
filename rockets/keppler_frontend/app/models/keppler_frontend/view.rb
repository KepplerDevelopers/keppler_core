# View Model
module KepplerFrontend
  class View < ActiveRecord::Base
    include ActivityHistory
    include CloneRecord
    include KepplerFrontend::Concerns::ActionFile
    include KepplerFrontend::Concerns::StringActions
    include KepplerFrontend::Concerns::CallbackActions
    require 'csv'
    acts_as_list
    validates_presence_of :name, :url
    validates_uniqueness_of :name, :url
    before_validation :convert_to_downcase, :without_special_characters
    has_many :view_callbacks, dependent: :destroy, inverse_of: :view
    accepts_nested_attributes_for :view_callbacks, reject_if: :all_blank, allow_destroy: true
    delegate :install, :install_html, :install_remote_js, :install_only_action, to: :view_install_files
    delegate :change_name, to: :view_update_files
    delegate :uninstall, :uninstall_html, :uninstall_remote_js, :uninstall_only_action, to: :view_uninstall_files
    delegate :install, :uninstall, to: :routes, prefix: true
    delegate :html, :scss, :action, :js, :remote_js, to: :output, prefix: true

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

    def route
      "/admin/frontend/views/#{self.id}/editor"
    end

    def code_save(code, type_code)
      if type_code.eql?('html')
        save_html_code("#{url_front}/app/views/keppler_frontend/app/frontend/#{name}.html.erb", code, name)
      elsif type_code.eql?('scss')
        save_code("#{url_front}/app/assets/stylesheets/keppler_frontend/app/views/#{name}.scss", code)
      elsif type_code.eql?('js')
        save_code("#{url_front}/app/assets/javascripts/keppler_frontend/app/views/#{name}.js", code)
      elsif type_code.eql?('js_erb')
        save_code("#{url_front}/app/views/keppler_frontend/app/frontend/#{name}.js.erb", code)
      elsif type_code.eql?('action')
        save_action(code) # Solo falta esta función por llevar a services
      end
    end

    def save_code(file, code)
      File.delete(file) if File.exist?(file)
      out_file = File.open(file, "w")
      out_file.puts(code)
      out_file.close
    end

    def save_html_code(file, code, name)
      File.delete(file) if File.exist?(file)
      out_file = File.open(file, "w")
      out_file.puts("<keppler-view id='#{name}'>\n#{code}\n</keppler-view>")
      out_file.close
    end

    def new_callback(view, callbacks)
      return unless callbacks
      callbacks.each do |key, value|
        if value[:name]
          callback = ViewCallback.where(name: value[:name], function_type: value[:function_type])
          add_callback_to(view, value) if callback.count == 1
        end
      end
    end

    private

    def url_front
      "#{Rails.root}/rockets/keppler_frontend"
    end

    def routes
      KepplerFrontend::Views::RoutesHandler.new(self)
    end  

    def view_install_files
      KepplerFrontend::Views::Install.new(self)
    end

    def view_update_files
      KepplerFrontend::Views::Update.new(self)
    end

    def view_uninstall_files
      KepplerFrontend::Views::Uninstall.new(self)
    end

    def output
      KepplerFrontend::Views::Output.new(self)
    end

    def convert_to_downcase
      self.url.downcase!
      self.name.downcase!
    end

    def without_special_characters
      self.name = self.name.split('').select { |x| x if not_special_chars.include?(x) } .join
      self.url = self.url.split('').select { |x| x if not_special_chars.include?(x) || x.eql?('/')} .join
    end
  end
end
