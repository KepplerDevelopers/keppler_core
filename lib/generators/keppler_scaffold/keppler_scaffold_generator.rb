require 'rails/generators/rails/resource/resource_generator'
require 'rails/generators/resource_helpers'
module Rails
  module Generators
    # KepplerScaffold
    class KepplerScaffoldGenerator < ResourceGenerator
      remove_hook_for :resource_controller
      remove_class_option :actions

      class_option :stylesheets, type: :boolean, desc: 'Generate Stylesheets'
      class_option :stylesheet_engine, desc: 'Engine for Stylesheets'
      remove_class_option :resource_route, type: :boolean

      source_root File.expand_path('../templates', __FILE__)

      check_class_collision suffix: 'Controller'

      class_option(
        :orm,
        banner: 'NAME',
        type: :string,
        required: true,
        desc: 'ORM to generate the controller for'
      )

      argument(
        :attributes,
        type: :array,
        default: [],
        banner: 'field:type field:type'
      )

      def add_route
        unless options[:skip_routes]
          inject_into_file(
            'config/routes.rb',
            "\n #{indent(str_route)}",
            after: 'namespace :admin do'
          )
        end
      end

      def add_option_menu
        inject_into_file(
          'config/menu.yml',
          str_menu,
          before: '  user:'
        )
      end

      def add_access_ability
        inject_into_file(
          'app/models/ability.rb',
          str_ability,
          after: '    if user.has_role? :admin'
        )
      end

      def add_locales
        %w(en es).each do |locale|
          add_str_locales(locale, 'singularize')
          add_str_locales(locale, 'pluralize')
          add_str_locales(locale, 'modules')
          add_str_locales(locale, 'sidebar-menu')
        end
      end

      def create_controller_files
        template(
          'controllers/controller.rb',
          File.join(
            'app/controllers/admin',
            controller_class_path, "#{controller_file_name}_controller.rb"
          )
        )
      end

      def create_model_files
        template(
          'models/model.rb',
          File.join(
            'app/models',
            controller_class_path,
            "#{controller_file_name.singularize}.rb"
          )
        )
      end

      def create_views_files
        template_keppler_views('_description.html.haml')
        template_keppler_views('_index_show.html.haml')
        template_keppler_views('_listing.html.haml')
        template_keppler_views('_form.html.haml')
        template_keppler_views('show.js.haml')
        template_keppler_views('edit.html.haml')
        template_keppler_views('new.html.haml')
        template_keppler_views('show.html.haml')
        template_keppler_views('index.html.haml')
      end

      hook_for :test_framework, as: :scaffold

      # Invoke the helper using the controller name (pluralized)
      hook_for :helper, as: :scaffold do |invoked|
        invoke invoked, [controller_name]
      end

      private

      def add_str_locales(locale, switch)
        inject_into_file(
          "config/locales/#{locale}.yml",
          str_locales(switch),
          after: "#{switch}:"
        )
      end

      def str_route
        " resources :#{controller_file_name} do\n    get '(page/:page)', action: :index, on: :collection, as: ''\n    get '/clone', action: 'clone'\n    delete(\n      action: :destroy_multiple,\n      on: :collection,\n      as: :destroy_multiple\n    )\n  end\n"
      end

      def str_menu
        "  #{controller_file_name.singularize}:\n    name: #{controller_file_name.humanize.downcase}\n    url_path: /admin/#{controller_file_name}\n    icon: insert_chart\n    current: ['admin/#{controller_file_name}']\n    model: #{controller_file_name.singularize.camelize}\n"
      end

      def str_ability
        "\n\n      # - #{controller_file_name.singularize.camelcase} authorize -\n      can :manage, #{controller_file_name.singularize.camelcase}"
      end

      def str_locales(switch)
        case switch
        when 'singularize'
          "\n        #{controller_file_name.singularize}: #{controller_file_name.singularize.humanize.downcase}"
        when 'pluralize'
          "\n        #{controller_file_name}: #{controller_file_name.humanize.downcase}"
        when 'modules'
          "\n      admin/#{controller_file_name}: #{controller_file_name.humanize}"
        when 'sidebar-menu'
          "\n      #{controller_file_name}: #{controller_file_name.humanize}"
        end
      end

      def template_keppler_views(name_file)
        template(
          "views/#{name_file}",
          File.join("app/views/admin/#{controller_file_name}",  name_file)
        )
      end

      def arr_exist(path, search)
        object = []
        open(path).each do |line|
          object << line if line.to_s.include? search
        end
        object
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
