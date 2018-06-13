# frozen_string_literal: true

module Admin
  # TemplateService
  class TemplateService


    def initialize(file)
      @file = file
    end

    def name(file)
      "#{file.to_s.split('/').last.split('.').first.capitalize} Template"
    end

    def install
      clear_template
      unzip_template
      install_template_html
      [:css, :img, :js, :fonts].each do |stack|
        install_template(stack)
      end
    end

    def uninstall
      clear_template
    end

    def set_defaut
      clear_template
    end

    private

    def dir
      {
        template: 'public/templates',
        css: 'app/assets/stylesheets/css',
        img: 'app/assets/images/img',
        fonts: 'app/assets/images/fonts',
        js: 'app/assets/javascripts/js'
      }
    end

    def clear_template
      file_name = Dir[File.join("#{Rails.root}/#{dir[:template]}", '**', '*')].first
      template_name = file_name.split('/').last if file_name
      names = build_array_html_files_names(template_name, 'html')
      system "rails d keppler_front front #{names.join(' ')}"
      system "rm -rf #{Rails.root}/app/views/app/front/"
      [:template, :css, :img, :fonts, :js].each do |stack|
        clear_assets("#{Rails.root}/#{dir[stack]}")
      end
      system "rails g keppler_front front index --skip-migration -f"
      system "rm -rf #{Rails.root}/app/model/front.rb"
    end

    def unzip_template
      system "unzip #{Rails.root}/public/#{@file} -d #{Rails.root}/public/templates"
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

    def install_template(stack)
      folder = "#{Rails.root}/#{dir[stack]}"
      clear_assets(folder)
      template_name = Dir[File.join("#{Rails.root}/public/templates", '**', '*')].first.split("/").last
      names = build_array_assets_files_names(template_name, "#{stack}")
      names.each do |name|
        system "cp #{Rails.root}/public/templates/#{template_name}/assets/#{stack}/#{name} #{folder}/#{name}"
      end
    end

    def add_assets_keppler(folder, name)
      index_html = File.readlines("#{folder}/#{name}.html.haml")
      head_idx = 0
      index_html.each do |i|
        head_idx = index_html.find_index(i) if i.include?('%html')
      end
      index_html.insert(head_idx.to_i + 2, "    = render 'app/layouts/head'\n")
      index_html = index_html.join('')
      File.write("#{folder}/#{name}.html.haml", index_html)
    end
  end
end