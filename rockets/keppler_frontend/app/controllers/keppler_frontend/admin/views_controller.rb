require_dependency "keppler_frontend/application_controller"
module KepplerFrontend
  module Admin
    # ViewsController
    class ViewsController < ApplicationController
      layout 'keppler_frontend/admin/layouts/application'
      before_action :only_development
      before_action :authorization
      before_action :set_data, only: [:index, :refresh, :remove]
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
        @obj = view_obj(params)
        if object_validate(@obj)
          views.add(@obj)
        else
          @error = t('route_errors.exist')
        end
        set_data
      end

      def remove
        file = @views[params[:file].to_i].first
        if route_exist?(file)
          views.remove(file)
        end
        set_data
      end

      private

      def authorization
        authorize Theme
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

      def route_exist?(file)
        result = route_handler.search_route(file)
        result.blank? ? false : true
      end

      def object_validate(obj)
        file = file_name(obj)
        no_exist = route_handler.search_route(file).blank?
        no_empty = !obj[:name].blank? && !obj[:url].blank?
        no_exist && no_empty
      end

      def file_name(obj)
        "/frontend/#{obj[:name]}.html.#{obj[:view_format]}"
      end
  
      def name_without_special_characters(name)
        name = name.downcase
        name = name.split('').select do
          |x| x if not_special_chars.include?(x) 
        end
        name.join
      end

      def url_without_special_characters(url)
        url = url.downcase
        url = url.split('').select do |x| 
          x if not_special_chars.include?(x) || x.eql?('/') 
        end
        url.join
      end
    end
  end
end

