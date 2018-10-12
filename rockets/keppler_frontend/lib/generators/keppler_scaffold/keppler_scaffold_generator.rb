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
        eturn if  options[:skip_routes]
        inject_into_file(
          'config/routes.rb',
          "\n #{indent(str_route)}",
          after: 'scope :frontend, as: :frontend do'
        )
      end

      #def add_option_menu
      #  inject_into_file(
      #    'config/menu.yml',
      #    str_menu,
      #    before: '  user:'
      #  )
      #end

      #def add_access_ability
      #  inject_into_file(
      #    'app/models/ability.rb',
      #    str_ability,
      #    after: '    if user.has_role? :admin'
      #  )
      #end

      #def add_locales
      #  %w(en es).each do |locale|
      #    add_str_locales(locale, 'singularize')
      #    add_str_locales(locale, 'pluralize')
      #    add_str_locales(locale, 'modules')
      #    add_str_locales(locale, 'sidebar-menu')
      #  end
      #end

      def add_option_permissions
        inject_into_file(
          'config/permissions.yml',
          "\n#{indent(str_permissions, 2)}",
          after: 'modules:'
        )
      end

      def create_controller_files
        template(
          'controllers/controller.rb',
          File.join(
            'app/controllers/',
            controller_class_path, "/admin/#{controller_file_name}_controller.rb"
          )
        )
      end

      def create_model_files
        attachments
        template(
          'models/model.rb',
          File.join(
            'app/models',
            controller_class_path,
            "#{controller_file_name.singularize}.rb"
          )
        )
      end

      def create_policies_files
        template(
          'policies/policy.rb',
          File.join(
            'app/policies',
            controller_class_path, "#{controller_file_name.singularize}_policy.rb"
          )
        )
      end

      def create_views_files
        %w[
          _description _form _listing
          edit index new show
          reload.js
        ].each do |filename|
          template_keppler_views("#{filename}.haml")
        end
      end

      hook_for :test_framework, as: :scaffold

      # Invoke the helper using the controller name (pluralized)
      hook_for :helper, as: :scaffold do |invoked|
        invoke invoked, [controller_name]
      end

      private

      #def add_str_locales(locale, switch)
      #  inject_into_file(
      #    "config/locales/#{locale}.yml",
      #    str_locales(switch),
      #    after: "#{switch}:"
      #  )
      #end

      def names
        @names = ['name', 'title', 'first_name', 'full_name']
      end

      def attachments
        SINGULAR_ATTACHMENTS = ['logo', 'brand', 'photo', 'avatar', 'cover', 'image', 'picture', 'banner', 'attachment', 'pic', 'file']
      end

      def str_route
        <<~HEREDOC
          resources :#{MODULE_NAME} do
            post '/sort', action: :sort, on: :collection
            get '(page/:page)', action: :index, on: :collection, as: ''
            get '/clone', action: 'clone'
            post '/upload', action: 'upload', as: :upload
            get '/reload', action: :reload, on: :collection
            delete '/destroy_multiple', action: :destroy_multiple, on: :collection
          end
        HEREDOC
      end

      def str_menu
        <<~HEREDOC
          - #{MODULE_NAME.singularize}:
              name: #{MODULE_NAME.humanize.downcase}
              url_path: /admin/#{ROCKET_NAME.split('keppler_').last}/#{MODULE_NAME.pluralize}
              icon: layers
              current: ['/admin/#{ROCKET_NAME.split('keppler_').last}/#{MODULE_NAME.pluralize}']
              model: #{ROCKET_CLASS_NAME}::#{MODULE_CLASS_NAME}
        HEREDOC
      end

      def str_permissions
        <<~HEREDOC
        #{MODULE_NAME.pluralize}:
          name: #{MODULE_CLASS_NAME}
          model: #{ROCKET_CLASS_NAME}#{MODULE_CLASS_NAME}
          actions: [
            'index', 'create', 'update', 'destroy', 'download', 'upload', 'clone'
          ]
        HEREDOC
      end

      def str_locales(switch)
        case switch
        when "#{ROCKET_NAME.dasherize}-submenu"
          "        #{MODULE_NAME.dasherize}: #{MODULE_NAME.humanize}"
        when 'singularize'
          "        #{MODULE_NAME.singularize}: #{MODULE_NAME.singularize.humanize.downcase}"
        when 'pluralize'
          "        #{MODULE_NAME.pluralize}: #{MODULE_NAME.pluralize.humanize.downcase}"
        when 'modules'
          "      admin/#{MODULE_NAME.dasherize}: #{MODULE_NAME.humanize}"
        end
      end

      def template_keppler_views(name_file)
        template(
          "views/#{name_file}",
          File.join("app/views/#{controller_class_path.first}/admin/#{controller_file_name}",  name_file)
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
