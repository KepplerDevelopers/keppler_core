# Theme Model
module KepplerFrontend
  class Theme < ActiveRecord::Base
    include ActivityHistory
    include CloneRecord
    require 'csv'
    acts_as_list
    before_destroy :uninstall
    include KepplerFrontend::Concerns::LayoutFile
    include KepplerFrontend::Concerns::StringActions
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
      return false if has_a_special_characters(theme_folder)
      assets_folder = File.directory?("#{Rails.root}/#{theme_folder}/assets/themes/")
      html_folder = File.directory?("#{Rails.root}/#{theme_folder}/views")
      covers_folder = File.directory?("#{Rails.root}/#{theme_folder}/covers")
      components_folder = File.directory?("#{Rails.root}/#{theme_folder}/components")
      layout_field = File.file?("#{Rails.root}/#{theme_folder}/layouts/application.html.erb")

      if assets_folder && html_folder && covers_folder && layout_field && components_folder
        true
      else
        post_install(new_file.original_filename)
        false
      end
    end

    def install(new_file)
      theme_folder = new_file.original_filename.split('.').first
      install_layout(theme_folder)
      install_views(theme_folder)
      install_components(theme_folder)
      install_assets(theme_folder)
      post_install(new_file.original_filename)
    end


    def install_layout(folder)
      new_folder = "#{url_front}/app/views/layouts/themes/#{folder.downcase.gsub(' ', '_').gsub('-', '_')}"
      FileUtils::mkdir_p new_folder
      layout_file = "#{Rails.root}/#{folder}/layouts/application.html.erb"
      FileUtils.mv(layout_file, new_folder)
    end

    def install_views(folder)
      old_theme_folder = "#{Rails.root}/#{folder}/views"
      scripts = Dir.entries(old_theme_folder)
      theme_folder = "#{url_front}/app/assets/html/themes/#{folder.downcase.gsub(' ', '_').gsub('-', '_')}"
      covers_folder = "#{Rails.root}/#{folder}/covers"
      FileUtils::mkdir_p "#{theme_folder}/views"
      FileUtils.mv(covers_folder, theme_folder)
      scripts.each do |script|
        unless script.eql?('.') || script.eql?('..')
          FileUtils.mv("#{old_theme_folder}/#{script}", "#{theme_folder}/views")
        end
      end
    end

    def install_components(folder)
      old_theme_folder = "#{Rails.root}/#{folder}/components"
      scripts = Dir.entries(old_theme_folder)
      theme_folder = "#{url_front}/app/assets/html/themes/#{folder.downcase.gsub(' ', '_').gsub('-', '_')}"
      FileUtils::mkdir_p "#{theme_folder}/components"
      scripts.each do |script|
        unless script.eql?('.') || script.eql?('..')
          FileUtils.mv("#{old_theme_folder}/#{script}", "#{theme_folder}/components")
        end
      end
    end

    def install_assets(folder)
      assets_theme = "#{Rails.root}/#{folder.split('.').first}/assets/themes/#{folder.downcase.gsub(' ', '_').gsub('-', '_')}"
      assets_core = "#{url_front}/app/assets"
      assets = Dir.entries(assets_theme)
      assets.each do |asset|
        if validate_format(asset)
          assets_type = select_folder(asset)
          theme_folder = "#{assets_core}/#{assets_type}/themes/#{folder.downcase.gsub(' ', '_').gsub('-', '_')}"
          FileUtils::mkdir_p theme_folder unless File.directory?(theme_folder)
          FileUtils.mv("#{assets_theme}/#{asset}", theme_folder)
        end
      end
    end

    def uninstall
      return if !self || self.active.eql?(true)
      views_folder = "#{url_front}/app/views/layouts/themes/#{self.name}"
      FileUtils.rm_rf(views_folder)
      all_folders.each do |folder|
        assets_folder = "#{url_front}/app/assets/#{folder}/themes/#{self.name}"
        FileUtils.rm_rf(assets_folder)
      end
    end

    def covers
      theme = self.name.downcase.gsub(' ', '_')
      covers_files = "#{url_front}/app/assets/html/themes/#{theme}/covers"
      return [] unless File.directory?(covers_files)
      covers = Dir.entries(covers_files)
      result = []
      covers.each do |cover|
        result << "/assets/themes/#{theme}/covers/#{cover}" if validate_format(cover)
      end
      result.sort
    end

    def desactived
      old_theme = Theme.where(active: true).first.name
      old_layout = "#{url_front}/app/views/layouts/keppler_frontend/app/layouts/application.html.erb"
      File.delete(old_layout) if File.exist?(old_layout)

      ['html'].each do |folder|
        if folder.eql?('html')
          delete_html_theme(old_theme, 'views')
          delete_html_theme(old_theme, 'components')
        end
      end
    end

    def actived
      new_theme = self.name
      new_layout = "#{url_front}/app/views/layouts/themes/#{new_theme}/application.html.erb"
      app_folder = "#{url_front}/app/views/layouts/keppler_frontend/app/layouts/"
      FileUtils.cp(new_layout, app_folder) if File.exist?(new_layout)

      ['html'].each do |folder|
        if folder.eql?('html')
          copy_html_theme(new_theme, 'views')
          copy_html_theme(new_theme, 'components')
        end
      end
    end

    private

    def url_front
      "#{Rails.root}/rockets/keppler_frontend"
    end

    def copy_html_theme(new_theme, html_type)
      theme_folder = "#{url_front}/app/assets/html/themes/#{new_theme}/#{html_type}"
      html_type = html_type.eql?('views') ? html_type : 'app'
      app_folder = "#{url_front}/app/assets/html/keppler_frontend/#{html_type}"
      if File.directory?(theme_folder)
        Dir.entries(theme_folder).each do |asset|
          unless asset.eql?('.') || asset.eql?('..') || asset.eql?('covers')
            FileUtils.cp("#{theme_folder}/#{asset}", app_folder)
          end
        end
      end
    end

    def delete_html_theme(old_theme, html_type)
      theme_folder = "#{url_front}/app/assets/html/themes/#{old_theme}/#{html_type}"
      html_type = html_type.eql?('views') ? html_type : 'app'
      app_folder = "#{url_front}/app/assets/html/keppler_frontend/#{html_type}"
      if File.directory?(theme_folder)
        Dir.entries(theme_folder).each do |asset|
          unless asset.eql?('.') || asset.eql?('..') || asset.eql?('covers')
            File.delete("#{app_folder}/#{asset}") if File.exist?("#{app_folder}/#{asset}")
          end
        end
      end
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
