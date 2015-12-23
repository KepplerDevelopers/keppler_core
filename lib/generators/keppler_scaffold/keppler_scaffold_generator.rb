require 'rails/generators/rails/resource/resource_generator'
require 'rails/generators/resource_helpers'
module Rails
  module Generators
    class KepplerScaffoldGenerator < ResourceGenerator
      remove_hook_for :resource_controller
      remove_class_option :actions

      class_option :stylesheets, type: :boolean, desc: "Generate Stylesheets"
      class_option :stylesheet_engine, desc: "Engine for Stylesheets"
      #class_option :assets, type: :boolean
      remove_class_option :resource_route, type: :boolean

      #def handle_skip
      #  @options = @options.merge(stylesheets: false) unless options[:assets]
      #  @options = @options.merge(stylesheet_engine: false) unless options[:stylesheets]
      #end

      source_root File.expand_path('../templates', __FILE__)

      check_class_collision suffix: "Controller"

      class_option :orm, banner: "NAME", type: :string, required: true,
                         desc: "ORM to generate the controller for"

      argument :attributes, type: :array, default: [], banner: "field:type field:type"

      def add_routes
        unless options[:skip_routes]
          begin_scope = indent("scope :admin do\n", 0)
          begin_resource = indent("    resources :#{controller_file_name} do\n", 0)
          get_resource = indent("    get '(page/:page)', action: :index, on: :collection, as: ''\n", 2)
          delete_resource = indent("    delete '/destroy_multiple', action: :destroy_multiple, on: :collection, as: :destroy_multiple\n", 2)
          end_resouce =  indent("    end\n", 0)
          end_scope =  indent("  end\n", 0)
          
          route begin_scope + begin_resource + get_resource + delete_resource + end_resouce + end_scope
        end
      end 

      def add_access_to_ability
        if arr_exist('app/models/ability.rb', "#{controller_file_name.singularize.humanize}").empty?
          line = "can :destroy, User do |u| !u.eql?(user) end"
          gsub_file 'app/models/ability.rb', /(#{Regexp.escape(line)})/mi do |match|
            "#{match}\n\n      can :manage, #{controller_file_name.singularize.humanize}"
          end
        else
          arr_exist('app/models/ability.rb', "#{controller_file_name.singularize.humanize}").each do |access|
            line = access
            gsub_file 'app/models/ability.rb', /(#{Regexp.escape(line)})/mi do |match|
              ""
            end
          end         
        end
      end

      def add_locale_en
        if arr_exist('config/locales/en.yml', "#{controller_file_name.singularize}").empty?
          line = 'singularize:'
          gsub_file 'config/locales/en.yml', /(#{Regexp.escape(line)})/mi do |match|
            "#{match}\n        #{controller_file_name.singularize}: #{controller_file_name.singularize.humanize.downcase}"
          end
          line = 'pluralize:'
          gsub_file 'config/locales/en.yml', /(#{Regexp.escape(line)})/mi do |match|
            "#{match}\n        #{controller_file_name}: #{controller_file_name.humanize.downcase}"
          end
          line = 'modules:'
          gsub_file 'config/locales/en.yml', /(#{Regexp.escape(line)})/mi do |match|
            "#{match}\n      #{controller_file_name}: #{controller_file_name.humanize}"
          end
        else
          arr_exist('app/models/ability.rb', "#{controller_file_name.singularize.humanize}").each do |access|
            line = access
            gsub_file 'app/models/ability.rb', /(#{Regexp.escape(line)})/mi do |match|
              ""
            end
          end
        end
      end

      def add_menu
        if arr_exist('config/menu.yml', "#{controller_file_name.singularize}").empty?
          line = 'current: ["users"]'
          gsub_file 'config/menu.yml', /(#{Regexp.escape(line)})/mi do |match|
            "#{match}\n  #{controller_file_name.singularize}:\n    name: #{controller_file_name.humanize.downcase}\n    url_path: /admin/#{controller_file_name}\n    icon: account_circle\n    current: ['#{controller_file_name}']"
          end
        end
      end

      def create_controller_files
        template "controller.rb", File.join('app/controllers', controller_class_path, "#{controller_file_name}_controller.rb")
      end

      def create_model_files
        template "model.rb", File.join('app/models', controller_class_path, "#{controller_file_name.singularize}.rb")
      end

      def create_views_files
        template "_description.html.haml", File.join("app/views/#{controller_file_name}",  "_description.html.haml")
        template "_index_show.html.haml", File.join("app/views/#{controller_file_name}",  "_index_show.html.haml")
        template "_listing.html.haml", File.join("app/views/#{controller_file_name}",  "_listing.html.haml")
        template "show.js.haml", File.join("app/views/#{controller_file_name}",  "show.js.haml")
        template "_form.html.haml", File.join("app/views/#{controller_file_name}",  "_form.html.haml")
        template "edit.html.haml", File.join("app/views/#{controller_file_name}",  "edit.html.haml")
        template "new.html.haml", File.join("app/views/#{controller_file_name}",  "new.html.haml")
        template "show.html.haml", File.join("app/views/#{controller_file_name}",  "show.html.haml")
        template "index.html.haml", File.join("app/views/#{controller_file_name}",  "index.html.haml")
      end

      def create_assets_files        
        template "script.coffee", File.join("app/assets/javascripts/admin",  "#{controller_file_name}.coffee")
        template "style.scss", File.join("app/assets/stylesheets/admin",  "#{controller_file_name}.scss")
      end

      hook_for :template_engine, :test_framework, as: :scaffold

      # Invoke the helper using the controller name (pluralized)
      hook_for :helper, as: :scaffold do |invoked|
        invoke invoked, [ controller_name ]
      end 

      private

        def arr_exist(path, search)
          object = []        
          open(path).each do |line|
            if line.to_s.include? search
              object << line
            end
          end
          return object
        end       

        def destination_path(path)
          File.join(destination_root, path)
        end

        def gsub_file(relative_destination, regexp, *args, &block)
          path = destination_path(relative_destination)
          content = File.read(path).gsub(regexp, *args, &block)
          File.open(path, 'wb') do |file| 
            file.write(content) 
          end
        end

    end
  end
end
