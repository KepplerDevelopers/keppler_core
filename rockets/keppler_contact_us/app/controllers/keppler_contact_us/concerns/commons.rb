module KepplerContactUs
  module Concerns
    # Concern con la configuracion de parametros de los formulario
    module Commons
      extend ActiveSupport::Concern

      included do
        before_action :paginator_params
        before_action :set_setting
        before_action :this_object, only: %i[show edit update destroy favorite reply share]
        before_action :query_objects#, only: %i[index reload sort favorite]
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def this_object
        param_id = params[:id] || params["#{controller_name.singularize}_id".to_sym]
        return if param_id.nil? || param_id.to_i.zero?
        @object = model.find(param_id)
      end

      def query_objects
        @q = model.ransack(params[:q])
        q = @q.result(distinct: true)
        @objects = q.page(@current_page).order(position: :desc)
        @total = q.size
      end

      def paginator_params
        @search_field = model.search_field if listing?
        @query = params[:search] unless params[:search].blank?
        @current_page = params[:page] unless params[:page].blank?
      end
      
      def module_name
        controller_path.split('/').split('admin').flatten.join('/').classify.constantize
      end

      # Get submit key to redirect, only [:create, :update]
      def redirect(object, commit)
        if commit.key?('_save')
          redirect_to([:admin, :ckn, object], notice: actions_messages(object))
        elsif commit.key?('_add_other')
          redirect_to(
            send("new_admin_#{underscore(object)}_path"),
            notice: actions_messages(object)
          )
        end
      end
    end
  end
end
