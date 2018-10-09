module KepplerFrontend
  module Concerns
    # Concern con la configuracion de parametros de los formulario
    module Commons
      extend ActiveSupport::Concern

      included do
        before_action :set_attachments
        before_action :paginator_params
        before_action :set_setting
      end

      private

      def set_attachments
        @attachments = %w[logo brand photo avatar cover image
                          picture banner attachment pic file]
      end

      def paginator_params
        @search_field = model.search_field if listing?
        @query = params[:search] unless params[:search].blank?
        @current_page = params[:page] unless params[:page].blank?
      end

      def set_setting
        @setting = Setting.first
      end

      def module_name
        self.class.to_s.split('::').first.constantize
      end

      # Get submit key to redirect, only [:create, :update]
      def redirect(object, commit)
        if commit.key?('_save')
          redirect_to(request.path.split('/')[1..-2].map(&:to_sym).push(object), notice: actions_messages(object))
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
