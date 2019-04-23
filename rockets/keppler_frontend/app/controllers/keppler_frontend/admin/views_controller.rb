require_dependency "keppler_frontend/application_controller"
module KepplerFrontend
  module Admin
    # ViewsController
    class ViewsController < ::Admin::AdminController
      layout 'keppler_frontend/admin/layouts/application'
      before_action :set_view, only: [:show, :edit, :update, :destroy]
      before_action :only_development

      include KepplerFrontend::Concerns::Services


      # GET /views
      def index
        @views = set_views
      end

      private

      # Only allow a trusted parameter "white list" through.
      def view_params
        params.require(:view).permit(:name, :url, :root_path, :method, :active, :format_result, :position, :deleted_at,
                                     view_callbacks_attributes: view_callbacks_attributes)
      end

      def files
        'rockets/keppler_frontend/app/views/keppler_frontend/app/**/*'
      end

      def set_views
        files_name = []
        Dir[files].each do |file|
          file = file.split('app').last
          if !partial?(file) && format_permit?(file)
            files_name <<  file unless file.include?('keppler.')
          end
        end
        files_name
      end

      def format_permit?(file)        
        file_format = file.split('.').last
        ['haml', 'erb'].include?(file_format)
      end

      def partial?(file)
        file.split('/').last.first.eql?('_')
      end

      # Get submit key to redirect, only [:create, :update]
      def redirect(object, commit)
        if commit.key?('_save')
          redirect_to([:admin, :frontend, object], notice: actions_messages(object))
        elsif commit.key?('_add_other')
          redirect_to(
            send("new_admin_frontend_#{underscore(object)}_path"),
            notice: actions_messages(object)
          )
        end
      end
    end
  end
end
