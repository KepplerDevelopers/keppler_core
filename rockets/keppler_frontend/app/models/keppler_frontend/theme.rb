# Theme Model
module KepplerFrontend
  class Theme < ActiveRecord::Base
    include ActivityHistory
    include CloneRecord
    require 'csv'
    acts_as_list
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

    def url_front
      "#{Rails.root}/rockets/keppler_frontend"
    end

    def install(file, new_file)
      root = "#{Rails.root}/public/keppler_frontend"
      old_name = "#{root}/#{file.filename}"
      new_name = "#{root}/#{new_file.original_filename}"
      File.rename(old_name, new_name)
      system("unzip #{new_name}")
      theme_folder = new_file.original_filename.split('.').first
      # install_layout(theme_folder)
      install_html(theme_folder)
      clear(new_file.filename)
    end


    def install_layout(folder)
      new_folder = "#{url_front}/app/views/layouts/keppler_frontend/themes/#{folder}"
      FileUtils::mkdir_p new_folder
      layout_file = "#{Rails.root}/#{folder}/layouts/application.html.erb"
      covers_folder = "#{Rails.root}/#{folder}/covers"
      FileUtils.mv(layout_file, new_folder)
      FileUtils.mv(covers_folder, new_folder)
    end

    def install_html(folder)
      old_theme_folder = "#{Rails.root}/#{folder}/html"
      scripts = Dir.entries(old_theme_folder)
      theme_folder = "#{url_front}/app/assets/html/keppler_frontend/themes/#{folder}"
      FileUtils::mkdir_p theme_folder
      scripts.each do |script|
        unless script.eql?('.') || script.eql?('..')
          FileUtils.mv("#{old_theme_folder}/#{script}", "#{theme_folder}")
        end
      end
    end

    def clear(theme)
      theme_folder = "#{Rails.root}/#{theme.split('.').first}"
      theme_zip = "#{Rails.root}/public/keppler_frontend/#{theme}"
      FileUtils.rm_rf(theme_folder)
      FileUtils.rm_rf(theme_zip)
    end

  end
end
