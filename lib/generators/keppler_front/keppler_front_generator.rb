require 'rails/generators/rails/resource/resource_generator'
require 'rails/generators/resource_helpers'
module Rails
  module Generators
    # KepplerScaffold
    class KepplerFrontGenerator < ResourceGenerator
      remove_hook_for :resource_controller
      remove_class_option :actions

      remove_class_option :resource_route, type: :boolean

      source_root File.expand_path('../templates', __FILE__)

      check_class_collision suffix: 'Controller'

      class_option(
        :orm,
        banner: 'NAME',
        type: :string,
        required: false,
        desc: 'ORM to generate the controller for'
      )

      argument(
        :attributes,
        type: :array,
        default: [],
        banner: 'field:type field:type'
      )

      def add_route
        attributes.each do |attribute|
          insert_into_file(
            'config/routes.rb',
            "\n  #{indent(str_route(attribute))}",
            after: 'localized do'
          )
        end
      end

      def create_route_locales
        %w[es en].each do |locale|
          attributes.each do |attribute|
            insert_into_file(
              "config/locales/routes.#{locale}.yml",
              "\n    #{attribute.name}: #{attribute.name}",
              after: 'routes:'
            )
          end
        end
      end

      def create_controller_files
        template(
          'controllers/controller.rb',
          File.join(
            'app/controllers/app',
            controller_class_path, "front_controller.rb"
          )
        )
      end

      def create_views_files
        attributes.each do |attribute|
          template_keppler_views("#{attribute.name}.html.haml")
        end
      end

      hook_for :test_framework, as: :scaffold

      # Invoke the helper using the controller name (pluralized)
      hook_for :helper, as: :scaffold do |invoked|
        invoke invoked, [controller_name]
      end

      private

      def add_str_locales(locale, switch)
        insert_into_file(
          "config/locales/#{locale}.yml",
          str_locales(switch),
          after: "#{switch}:"
        )
      end

      def str_route(attribute)
        "get '/#{attribute.name}', to: 'app/front##{attribute.name}', as: :app_#{attribute.name}"
      end

      def str_menu
        "  #{controller_file_name.singularize}:\n    name: #{controller_file_name.humanize.downcase}\n    url_path: /admin/#{controller_file_name}\n    icon: code\n    current: ['admin/#{controller_file_name}']\n    model: #{controller_file_name.singularize.camelize}\n"
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
          "views/template.html.haml",
          File.join("app/views/app/front",  name_file)
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
