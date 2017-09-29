require 'rails/generators/rails/resource/resource_generator'
require 'rails/generators/resource_helpers'
module Rails
  module Generators
    class KepplerRelationGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)

      def modify_models
        inject_into_file(
          "app/models/#{name}.rb",
          "\n  has_many :#{args[0].pluralize}, :dependent => :delete_all",
          after: 'include CloneRecord'
        )
        inject_into_file(
          "app/models/#{args[0]}.rb",
          "\n  belongs_to :#{name}",
          after: 'include CloneRecord'
        )
      end

      def nest_routes
        gsub_file 'config/routes.rb', commented_route(args[0]), '    #Route deleted'
        inject_into_file(
          "config/routes.rb",
          str_route(args[0]),
          after:"    resources :#{name.pluralize} do\n      get '(page/:page)', action: :index, on: :collection, as: ''\n      get '/clone', action: 'clone'\n      delete(\n        action: :destroy_multiple,\n        on: :collection,\n        as: :destroy_multiple\n      )\n"
        )

      end

      def modify_views_path
        ["_listing", "index", "_form", "_index_show", "show"].each do |view|
          singular_path(name,args[0],view)
          if view == '_listing'
            clone_path(name,args[0],view)
            inject_listing(name, args[0], view)
          end
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

      def add_callback
        inject_into_file(
          "app/controllers/admin/#{args[0].pluralize}_controller.rb",
          str_callback_ctrl(name),
          after: "    before_action :show_history, only: [:index]"
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
        inject_into_file(
          "app/views/admin/#{name.pluralize}/_listing.html.haml",
          str_btn(name, args[0]),
          before: str_last_button(name)
        )
      end

      def new_params
        inject_into_file(
          "app/controllers/admin/#{args[0].pluralize}_controller.rb",
          "(#{name.underscore}_id: params[:#{name.underscore}_id])",
          after: "    def new\n      @#{args[0]} = #{args[0].camelcase}.new"
        )

      end

      def controller_paths
        gsub_file(
          "app/controllers/admin/#{args[0].pluralize}_controller.rb",
          "admin_#{args[0].pluralize}_path",
          "admin_#{name.underscore}_#{args[0].pluralize}_path"
        )

        gsub_file(
          "app/controllers/admin/#{args[0].pluralize}_controller.rb",
          "redirect(@#{args[0].underscore}, params)",
          redirect_path(name, args[0])
        )
      end

      def index_controller
        gsub_file(
          "app/controllers/admin/#{args[0].pluralize}_controller.rb",
          "params[:q]",
          "@#{name.underscore}_#{args[0].underscore}"
        )
        inject_into_file(
          "app/controllers/admin/#{args[0].pluralize}_controller.rb",
          ".where(#{name}_id: @#{name.underscore}_#{args[0].underscore})",
          after: "#{args[0].pluralize} = @q.result(distinct: true)"
        )

      end


      private

      def redirect_path(father,son)
        "if params.key?('_add_other')\n          redirect_to new_admin_#{father.underscore}_#{son.underscore}_path, notice: actions_messages(@#{son})\n        else\n          redirect_to admin_#{father.underscore}_#{son.pluralize}_path\n        end"
      end

      def singular_path(father,son,file)
        inject_into_file(
          "app/views/admin/#{son.pluralize}/#{file}.html.haml",
          "_#{father.underscore}",
          before: "_#{son}"
        )
      end

      # def pluralize_path(father,son,file)
      #   inject_into_file(
      #     "app/views/admin/#{son.pluralize}/#{file}.html.haml",
      #     "_#{father.underscore}",
      #     before: "_#{son.pluralize}_path"
      #   )
      # end

      def clone_path(father,son,file)
        inject_into_file(
          "app/views/admin/#{son.pluralize}/#{file}.html.haml",
          "_#{father.underscore}",
          before: "_#{son}_clone_path"
        )
      end

      def commented_route(path)
        "    resources :#{path.pluralize(2)} do\n      get '(page/:page)', action: :index, on: :collection, as: ''\n      get '/clone', action: 'clone'\n      delete(\n        action: :destroy_multiple,\n        on: :collection,\n        as: :destroy_multiple\n      )\n    end\n"
      end


      def str_route(path)
        "      resources :#{path.pluralize(2)} do\n        get '(page/:page)', action: :index, on: :collection, as: ''\n        get '/clone', action: 'clone'\n        delete(\n          action: :destroy_multiple,\n          on: :collection,\n          as: :destroy_multiple\n        )\n      end\n"
      end

      def str_ctrl_method(father, son)
        "\n\n    def set_#{father}\n      @#{father}_#{son} = #{father.camelcase}.find(params[:#{father.underscore}_id])\n    end\n"
      end

      def str_callback_ctrl(father)
        "\n    before_action :set_#{father.underscore}\n"
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

      def str_last_button(father)
        "	- if can? :clone, #{father.capitalize}"
      end

      def str_btn(father, son)
        "\n\t%td{style:'width: 5%'}\n\t\t= link_to admin_#{father}_#{son.pluralize}_path(#{father}), class: 'btn-floating waves-effect btn-flat' do\n\t\t\t= material_icon.md_24.store.css_class('md-dark')\n"
      end
    end
  end
end
