# Theme Model
module KepplerFrontend
  class Theme < ActiveRecord::Base
    include ActivityHistory
    include CloneRecord
    require 'csv'
    acts_as_list
    before_destroy :uninstall
    # Fields for the search form in the navbar
    def self.search_field
      fields = ["name", "active", "position", "deleted_at"]
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

    def validate_theme(file, new_file)
      root = "#{Rails.root}/public/keppler_frontend"
      old_name = "#{root}/#{file.filename}"
      new_name = "#{root}/#{new_file.original_filename.downcase.gsub(' ', '_').gsub('-', '_')}"
      File.rename(old_name, new_name)
      system("unzip #{new_name}")
      theme_folder = new_file.original_filename.split('.').first
      assets_folder = File.directory?("#{Rails.root}/#{theme_folder}/assets/keppler_frontend/app")
      html_folder = File.directory?("#{Rails.root}/#{theme_folder}/html")
      covers_folder = File.directory?("#{Rails.root}/#{theme_folder}/covers")
      layout_field = File.file?("#{Rails.root}/#{theme_folder}/layouts/application.html.erb")

      if assets_folder && html_folder && covers_folder && layout_field
        true
      else
        post_install(new_file.original_filename)
        false
      end
    end

    def install(new_file)
      theme_folder = new_file.original_filename.downcase.gsub(' ', '_').gsub('-', '_')
      install_layout(theme_folder)
      install_html(theme_folder)
      install_assets(theme_folder)
      post_install(new_file.original_filename)
    end


    def install_layout(folder)
      new_folder = "#{url_front}/app/views/layouts/keppler_frontend/themes/#{folder.downcase.gsub(' ', '_').gsub('-', '_')}"
      FileUtils::mkdir_p new_folder
      layout_file = "#{Rails.root}/#{folder}/layouts/application.html.erb"
      FileUtils.mv(layout_file, new_folder)
    end

    def install_html(folder)
      old_theme_folder = "#{Rails.root}/#{folder}/html"
      scripts = Dir.entries(old_theme_folder)
      theme_folder = "#{url_front}/app/assets/html/keppler_frontend/themes/#{folder.downcase.gsub(' ', '_').gsub('-', '_')}"
      covers_folder = "#{Rails.root}/#{folder}/covers"
      FileUtils::mkdir_p theme_folder
      FileUtils.mv(covers_folder, theme_folder)
      scripts.each do |script|
        unless script.eql?('.') || script.eql?('..')
          FileUtils.mv("#{old_theme_folder}/#{script}", "#{theme_folder}")
        end
      end
    end

    def install_assets(folder)
      assets_theme = "#{Rails.root}/#{folder.split('.').first}/assets/keppler_frontend/app"
      assets_core = "#{url_front}/app/assets"
      assets = Dir.entries(assets_theme)
      assets.each do |asset|
        if validate_format(asset)
          assets_type = select_folder(asset)
          theme_folder = "#{assets_core}/#{assets_type}/keppler_frontend/themes/#{folder.split('.').first.downcase.gsub(' ', '_').gsub('-', '_')}"
          FileUtils::mkdir_p theme_folder unless File.directory?(theme_folder)
          FileUtils.mv("#{assets_theme}/#{asset}", theme_folder)
        end
      end
    end

    def uninstall
      return if !self || self.active.eql?(true)
      views_folder = "#{url_front}/app/views/layouts/keppler_frontend/themes/#{self.name}"
      FileUtils.rm_rf(views_folder)
      all_folders.each do |folder|
        assets_folder = "#{url_front}/app/assets/#{folder}/keppler_frontend/themes/#{self.name}"
        FileUtils.rm_rf(assets_folder)
      end
    end

    def covers
      theme = self.name.downcase.gsub(' ', '_')
      covers = Dir.entries("#{url_front}/app/assets/html/keppler_frontend/themes/#{theme}/covers")
      result = []
      covers.each do |cover|
        result << "/assets/keppler_frontend/themes/#{theme}/covers/#{cover}" if validate_format(cover)
      end
      result.sort
    end

    def desactived
      old_theme = Theme.where(active: true).first.name
      old_layout = "#{url_front}/app/views/layouts/keppler_frontend/app/layouts/application.html.erb"
      File.delete(old_layout) if File.exist?(old_layout)

      all_folders.each do |folder|
        theme_folder = "#{url_front}/app/assets/#{folder}/keppler_frontend/themes/#{old_theme}"
        app_folder = "#{url_front}/app/assets/#{folder}/keppler_frontend/app"
        if File.directory?(theme_folder)
          Dir.entries(theme_folder).each do |asset|
            unless asset.eql?('.') || asset.eql?('..') || asset.eql?('covers')
              File.delete("#{app_folder}/#{asset}") if File.exist?("#{app_folder}/#{asset}")
            end
          end
        end
      end
    end

    def actived
      new_theme = self.name
      new_layout = "#{url_front}/app/views/layouts/keppler_frontend/themes/#{new_theme}/application.html.erb"
      app_folder = "#{url_front}/app/views/layouts/keppler_frontend/app/layouts/"
      FileUtils.cp(new_layout, app_folder) if File.exist?(new_layout)

      all_folders.each do |folder|
        theme_folder = "#{url_front}/app/assets/#{folder}/keppler_frontend/themes/#{new_theme}"
        app_folder = "#{url_front}/app/assets/#{folder}/keppler_frontend/app"
        if File.directory?(theme_folder)
          Dir.entries(theme_folder).each do |asset|
            unless asset.eql?('.') || asset.eql?('..') || asset.eql?('covers')
              FileUtils.cp("#{theme_folder}/#{asset}", app_folder)
            end
          end
        end
      end
    end

    private

    def url_front
      "#{Rails.root}/rockets/keppler_frontend"
    end

    def post_install(theme)
      theme_folder = "#{Rails.root}/#{theme.split('.').first}"
      theme_zip = "#{Rails.root}/public/keppler_frontend/#{theme.downcase.gsub(' ', '_').gsub('-', '_')}"
      FileUtils.rm_rf(theme_folder)
      FileUtils.rm_rf(theme_zip)
    end

    def select_folder(file)
      content_type = File.extname(file)
      result = ''
      file_formats.each do |key, value|
        result = key.to_s if value.include?(content_type)
      end
      result
    end

    def validate_format(file)
      content_type = File.extname(file)
      result = false
      file_formats.each do |key, value|
        result = true if value.include?(content_type)
      end
      result
    end

    def all_folders
      ['audios', 'fonts', 'images', 'videos', 'html', 'javascripts', 'stylesheets']
    end

    def file_formats
      {
        audios: ['.mp3'],
        fonts: ['.eot', '.otf', '.ttf', '.woff', '.woff2'],
        images: ['.jpg', '.jpeg', '.png', '.svg', '.gif', '.tiff', '.bmp'],
        videos: ['.mp4', '.mpeg', '.webm'],
        javascripts: ['.js', '.coffee'],
        stylesheets: ['.css', '.scss', '.sass'],
        html: ['.html', '.html.erb']
      }
    end

  end
end
