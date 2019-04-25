require_dependency "keppler_frontend/application_controller"
module KepplerFrontend
  module Admin
    # ViewsController
    class ViewsController < ApplicationController
      layout 'keppler_frontend/admin/layouts/application'
      before_action :only_development
      before_action :authorization
      before_action :set_data, only: [:index, :refresh, :generate]
      include KepplerFrontend::Concerns::Services
      include KepplerFrontend::Concerns::StringActions

      def index; end

      def select_theme
        theme_view.select_theme(params)
        redirect_to admin_frontend_views_path
      end

      def refresh; end

      def generate
        @error = false
        obj = view_obj(params)
        if !route_exist?(obj)
          views.add(obj)
        else
          @error = t('route_errors.exist')
        end
      end

      private

      def authorization
        authorize Theme
      end

      def views
        KepplerFrontend::Views::Views.new
      end

      def theme_view
        KepplerFrontend::Views::ThemeViews.new
      end

      def resources
        KepplerFrontend::Editor::Resources.new
      end

      def route_handler
        KepplerFrontend::Views::RoutesHandler.new
      end

      def set_data
        @views = views.all_with_routes
        @resources = resources.custom_list('views')
      end

      def view_obj(params)
        {
          name: name_without_special_characters(params[:name]),
          url: url_without_special_characters(params[:url]),
          method: params[:method],
          view_format: params[:view_format]
        }
      end

      def route_exist?(obj)
        file = "/frontend/#{obj[:name]}.html.#{obj[:view_format]}"
        result = route_handler.search_route(file)
        result.blank? ? false : true
      end
  
      def name_without_special_characters(name)
        name = name.downcase
        name.split('').select { |x| x if not_special_chars.include?(x) } .join
      end

      def url_without_special_characters(url)
        url = url.downcase
        url.split('').select { |x| x if not_special_chars.include?(x) || x.eql?('/') } .join
      end
    end
  end
end

