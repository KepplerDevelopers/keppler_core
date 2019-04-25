require_dependency "keppler_frontend/application_controller"
module KepplerFrontend
  module Admin
    # ViewsController
    class ViewsController < ApplicationController
      layout 'keppler_frontend/admin/layouts/application'
      before_action :only_development
      before_action :authorization
      include KepplerFrontend::Concerns::Services

      # GET /views
      def index
        @views = views_list.all_with_routes
        @resources = resources.custom_list('views')
      end

      def select_theme
        theme_view.select_theme(params)
        redirect_to admin_frontend_views_path
      end

      private

      def authorization
        authorize Theme
      end

      def views_list
        KepplerFrontend::ViewsList.new
      end

      def theme_view
        KepplerFrontend::ThemeViews.new
      end

      def resources
        KepplerFrontend::Editor::Resources.new
      end
    end
  end
end

