# Customize Model
class Customize < ApplicationRecord
  include ActivityHistory
  include CloneRecord
  mount_uploader :file, TemplateUploader

  # validates :file, uniqueness: true
  # Fields for the search form in the navbar
  def self.search_field
    :file_cont
  end

  def name
    if self.file?
      "#{self.file.to_s.split("/").last.split(".").first.capitalize} Template"
    else
      "Keppler Default"
    end
  end

  def install
    clear_template
    unzip_template
    install_template_html
    install_template_css
    install_template_images
    install_template_javascript
    install_template_fonts
  end

  def uninstall
    clear_template
  end

  def install_keppler_template
    clear_template
  end

  private

  def clear_template
    file_name =  Dir[File.join("#{Rails.root}/public/templates", '**', '*')].first
    template_name = file_name.split("/").last if file_name
    names = build_array_html_files_names(template_name, "html")
    system "rails d keppler_front front #{names.join(' ')}"
    system "rm -rf #{Rails.root}/app/views/app/front/"
    clear_assets("#{Rails.root}/public/templates")
    clear_assets("#{Rails.root}/app/assets/stylesheets/css")
    clear_assets("#{Rails.root}/app/assets/javascripts/js")
    clear_assets("#{Rails.root}/app/assets/images/img")
    clear_assets("#{Rails.root}/app/assets/images/fonts")
    system "rails g keppler_front front index --skip-migration -f"
    system "rm -rf #{Rails.root}/app/model/front.rb"
  end

  def unzip_template
    system "unzip #{Rails.root}/public/#{self.file} -d #{Rails.root}/public/templates"
  end

  def build_array_html_files_names(template_name, extention)
    names = []
    Dir[File.join("#{Rails.root}/public/templates/#{template_name}", '**', '*')].each do |file|
      if File.file?(file)
        name = file.to_s.split("/").last.split(".").first
        extentions = file.to_s.split("/").last.split(".").second
        if extentions.eql?(extention)
          names << name
        end
      end
    end
    return names
  end

  def build_array_assets_files_names(template_name, extention)
    names = []
    Dir[File.join("#{Rails.root}/public/templates/#{template_name}/assets/#{extention}", '**', '*')].each do |file|
      if File.file?(file)
        name = file.to_s.split("/").last
        names << name
      end
    end
    return names
  end

  def install_template_html
    system "rails d keppler_front front index"
    folder = "#{Rails.root}/app/views/app/front"
    template_name = Dir[File.join("#{Rails.root}/public/templates", '**', '*')].first.split("/").last
    names = build_array_html_files_names(template_name,  "html")
    system "rails g keppler_front front #{names.join(' ')} --skip-migration -f"
    system "rm -rf #{Rails.root}/app/model/front.rb"
    names.each do |name|
      system "rm -rf #{folder}/#{name}.html.haml"
      system "cp #{Rails.root}/public/templates/#{template_name}/#{name}.html #{folder}/#{name}.html"
      system "html2haml #{folder}/#{name}.html #{folder}/#{name}.html.haml"
      system "rm -rf #{folder}/#{name}.html"
      add_assets_keppler(folder, name)
    end
  end

  def clear_assets(folder)
    system "rm -rf #{folder}"
    system "mkdir #{folder}"
  end

  def install_template_css
    folder = "#{Rails.root}/app/assets/stylesheets/css"
    clear_assets(folder)
    template_name = Dir[File.join("#{Rails.root}/public/templates", '**', '*')].first.split("/").last
    names = build_array_assets_files_names(template_name, 'css')
    names.each do |name|
      system "cp #{Rails.root}/public/templates/#{template_name}/assets/css/#{name} #{folder}/#{name}"
    end
  end

  def install_template_images
    folder = "#{Rails.root}/app/assets/images/img"
    clear_assets(folder)
    template_name = Dir[File.join("#{Rails.root}/public/templates", '**', '*')].first.split("/").last
    names = build_array_assets_files_names(template_name, 'img')
    names.each do |name|
      system "cp #{Rails.root}/public/templates/#{template_name}/assets/img/#{name} #{folder}/#{name}"
    end
  end

  def install_template_fonts
    folder = "#{Rails.root}/app/assets/images/fonts"
    clear_assets(folder)
    template_name = Dir[File.join("#{Rails.root}/public/templates", '**', '*')].first.split("/").last
    names = build_array_assets_files_names(template_name, 'fonts')
    names.each do |name|
      system "cp #{Rails.root}/public/templates/#{template_name}/assets/fonts/#{name} #{folder}/#{name}"
    end
  end

  def install_template_javascript
    folder = "#{Rails.root}/app/assets/javascripts/js"
    clear_assets(folder)
    template_name = Dir[File.join("#{Rails.root}/public/templates", '**', '*')].first.split("/").last
    names = build_array_assets_files_names(template_name, 'js')
    names.each do |name|
      system "cp #{Rails.root}/public/templates/#{template_name}/assets/js/#{name} #{folder}/#{name}"
    end
  end

  def add_assets_keppler(folder, name)
    index_html = File.readlines("#{folder}/#{name}.html.haml")
    head_idx = 0
    index_html.each { |line| head_idx = index_html.find_index(line) if line.include?('%html') }
    index_html.insert(head_idx.to_i+2, "    = render 'app/layouts/head'\n")
    index_html = index_html.join("")
    File.write("#{folder}/#{name}.html.haml", index_html)
  end
end
