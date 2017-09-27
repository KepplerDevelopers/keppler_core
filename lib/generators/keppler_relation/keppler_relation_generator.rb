require 'rails/generators/rails/resource/resource_generator'
require 'rails/generators/resource_helpers'
module Rails
  module Generators
    class KepplerRelationGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)

      def modify_models
        inject_into_file(
          "app/models/#{name}.rb",
          "\n  has_many :#{args[0].pluralize}",
          after: 'include CloneRecord'
        )
        inject_into_file(
          "app/models/#{args[0]}.rb",
          "\n  belongs_to :#{name}",
          after: 'include CloneRecord'
        )
      end

      def nest_routes
        inject_into_file(
          "config/routes.rb",
          str_route(args[0]),
          after:"    resources :#{name.pluralize} do\n      get '(page/:page)', action: :index, on: :collection, as: ''\n      get '/clone', action: 'clone'\n      delete(\n        action: :destroy_multiple,\n        on: :collection,\n        as: :destroy_multiple\n      )\n"
        )
      end

      def modify_views_path
        ["_listing", "index", "_form", "_index_show", "show"].each do |view|
          inject_into_file(
            "app/views/admin/#{args[0].pluralize}/#{view}.html.haml",
            "_#{name}",
            before: "_#{args[0]}_path"
          )
          inject_into_file(
            "app/views/admin/#{args[0].pluralize}/#{view}.html.haml",
            "_#{name}",
            before: "_#{args[0]}_clone_path"
          )
          inject_into_file(
            "app/views/admin/#{args[0].pluralize}/#{view}.html.haml",
            "_#{name}",
            before: "_#{args[0].pluralize}_path"
          )
          inject_listing(name, args[0], view) if view == '_listing'
          inject_variable(name, args[0], view)
        end
      end

      #Add the method in the son controller to find the father :id
      def add_controller_flag
        inject_into_file(
          "app/controllers/admin/#{args[0].pluralize}_controller.rb",
          str_ctrl_method(name,args[0]),
          after: "    private"
        )
      end

      #Inject the variables in the simple_form_for of the form partial
      def inject_var_form
        inject_into_file(
          "app/views/admin/#{args[0].pluralize}/_form.html.haml",
          "@#{name}_#{args[0]}, ",
          before: "@#{args[0]}]"
        )
      end

      def nested_button

      end

      private

      def str_route(path)
        "      resources :#{path.pluralize(2)} do\n        get '(page/:page)', action: :index, on: :collection, as: ''\n        get '/clone', action: 'clone'\n        delete(\n          action: :destroy_multiple,\n          on: :collection,\n          as: :destroy_multiple\n        )\n      end\n"
      end

      def str_ctrl_method(father, son)
        "\n\n    def set_#{father}\n      @#{father}_#{son} = #{father.camelcase}.find(params[:id])\n    end\n"
      end

      def inject_variable(father, son, file)
        if file.eql?("_form")
          inject_into_file(
            "app/views/admin/#{args[0].pluralize}/#{file}.html.haml",
            "(@#{father.underscore}_#{son.underscore}, @#{son.underscore})",
            after: "admin_#{father.underscore}_#{son.underscore}_path"
          )
        end
        inject_into_file(
          "app/views/admin/#{args[0].pluralize}/#{file}.html.haml",
          ", @#{father.underscore}_#{son.underscore}",
          after: "(@#{son.underscore}"
        )
      end

      def inject_listing(father, son, file)
        inject_into_file(
          "app/views/admin/#{args[0].pluralize}/_listing.html.haml",
          ", @#{father.underscore}_#{son.underscore} ",
          after: "(#{son.underscore}"
        )
      end
    end
  end
end
