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
            after: "root to: 'admin#root'"
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

      # def add_access_ability
      #   inject_into_file(
      #     'app/models/ability.rb',
      #     str_ability_admin,
      #     after: '    if user.has_role? :keppler_admin'
      #   )
      #   inject_into_file(
      #     'app/models/ability.rb',
      #     str_ability_admin,
      #     after: '    elsif user.has_role? :admin'
      #   )
      #   inject_into_file(
      #     'app/models/ability.rb',
      #     str_ability_client,
      #     after: '    elsif user.has_role? :client'
      #   )
      # end

      def add_locales
        %w(en es).each do |locale|
          add_str_locales(locale, 'singularize')
          add_str_locales(locale, 'pluralize')
          add_str_locales(locale, 'modules')
          add_str_locales(locale, 'sidebar-menu')
          # add_str_locales(locale, 'attributes')
        end
      end

      # Se usa para configurar la exportación del ActiveRecords a .xls,
      # pero da problemas al borrar el KepplerScaffold

      # def add_config_xls
      #   inject_into_file(
      #     'config/initializers/mime_types.rb',
      #     str_xls,
      #     after: '# ActiveRecords to save as .xls'
      #   )
      # end

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
        names
        attachments
        template_keppler_views('_description.html.haml')
        template_keppler_views('_index_show.html.haml')
        template_keppler_views('_listing.html.haml')
        template_keppler_views('_form.html.haml')
        template_keppler_views('show.js.haml')
        template_keppler_views('edit.html.haml')
        template_keppler_views('new.html.haml')
        template_keppler_views('show.html.haml')
        template_keppler_views('index.html.haml')
        template_keppler_views('reload.js.haml')
      end

      hook_for :test_framework, as: :scaffold

      # Invoke the helper using the controller name (pluralized)
      hook_for :helper, as: :scaffold do |invoked|
        invoke invoked, [controller_name]
      end

      def add_position_field
        file = Dir::entries('db/migrate').sort.last
        #system "sudo apt-get update"
        inject_into_file(
          "db/migrate/#{file}",
          "t.integer :position\n      ",
          before: "t.timestamps null: false"
        )
      end

      private

      def names
        @names = ['name', 'title', 'first_name', 'full_name']
      end

      def attachments
        @attachments = ['logo', 'brand', 'photo', 'avatar', 'cover', 'image', 'picture', 'banner', 'attachment', 'pic', 'file']
      end

      def add_str_locales(locale, switch)
        inject_into_file(
          "config/locales/#{locale}.yml",
          str_locales(switch),
          after: "#{switch}:"
        )
      end

      def str_route
        "\n  resources :#{controller_file_name} do\n    get '(page/:page)', action: :index, on: :collection, as: ''\n    get '/clone', action: 'clone'\n    post '/import', action: 'import', as: :import\n    \n    get '/download', action: 'download', as: :download\n    post(\n      '/sort',\n      action: :sort,\n      on: :collection,\n    )\n    get(\n      '/reload',\n      action: :reload,\n      on: :collection,\n    )\n    delete(\n      '/destroy_multiple',\n      action: :destroy_multiple,\n      on: :collection,\n      as: :destroy_multiple\n    )
  end"
      end

      def str_menu
        "  #{controller_file_name.singularize}:\n    name: #{controller_file_name.humanize.downcase}\n    url_path: /admin/#{controller_file_name}\n    icon: layers\n    current: ['admin/#{controller_file_name}']\n    model: #{controller_file_name.singularize.camelize}\n"
      end

      # def str_ability_admin
      #   "\n\n      # - #{controller_file_name.singularize.camelcase} authorize -\n      can :manage, #{controller_file_name.singularize.camelcase}"
      # end
      #
      # def str_ability_client
      #   "\n\n      # - #{controller_file_name.singularize.camelcase} authorize -\n      can [:index, :show], #{controller_file_name.singularize.camelcase}"
      # end

      def str_xls
        "\nif #{controller_file_name.singularize.camelcase}.table_exists?\n  @#{controller_file_name.pluralize} = #{controller_file_name.singularize.camelcase}.all\n  @#{controller_file_name.pluralize}.to_xls(\n    only: %i[#{attributes_names.map { |name| name }.join(' ')}],\n    except: [:id],\n    header: false,\n    prepend: [['Col 0, Row 0', 'Col 1, Row 0'], ['Col 0, Row 1']],\n    column_width: [17, 15, 15, 40, 25, 37]\n  )\n  @#{controller_file_name.pluralize}.to_xls do |column, value|\n    column == :salutation ? t(value) : value\n  end\nend\n"
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
        # when 'attributes'
        #   array = ["\n      #{controller_file_name.singularize}:"]
        #   attributes_names.each do |attribute|
        #     array.push("\n        #{attribute}: #{attribute.humanize}")
        #   end
        #   array.join
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
