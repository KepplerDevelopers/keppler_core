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
      class_option :resource_route, type: :boolean

      #def handle_skip
      #  @options = @options.merge(stylesheets: false) unless options[:assets]
      #  @options = @options.merge(stylesheet_engine: false) unless options[:stylesheets]
      #end

      source_root File.expand_path('../templates', __FILE__)

      check_class_collision suffix: "Controller"

      class_option :orm, banner: "NAME", type: :string, required: true,
                         desc: "ORM to generate the controller for"

      argument :attributes, type: :array, default: [], banner: "field:type field:type"

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
        template "script.coffee", File.join("app/assets/javascripts/admin",  "#{controller_file_name}.coffee")
        template "style.scss", File.join("app/assets/stylesheets/admin",  "#{controller_file_name}.scss")
      end

      def create_assets_files
      end

      hook_for :template_engine, :test_framework, as: :scaffold

      # Invoke the helper using the controller name (pluralized)
      hook_for :helper, as: :scaffold do |invoked|
        invoke invoked, [ controller_name ]
      end

      
    end
  end
end
