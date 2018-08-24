# frozen_string_literal: true

module Admin
  # AdminController
  class AdminController < ::ApplicationController
    layout 'admin/layouts/application'
    before_action :authenticate_user!
    before_action :validate_permissions
    before_action :paginator_params
    before_action :set_setting
    before_action :can_multiple_destroy, only: [:destroy_multiple]
    before_action :tables_name

    def root
      if current_user
        redirect_to dashboard_path
      else
        redirect_to new_user_session_path
      end
    end

    def paginator_params
      @search_field = model.search_field if listing?
      @query = params[:search] unless params[:search].blank?
      @current_page = params[:page] unless params[:page].blank?
    end

    def validate_permissions
      return if current_user.rol.eql?('keppler_admin')
      redirect_to frontend_path unless current_user.permissions?
    end

    private

    def get_history(model)
      @activities = PublicActivity::Activity.where(
        trackable_type: model.to_s
      ).order('created_at desc').limit(50)
    end

    def tables_name
      @models = ApplicationRecord.connection.tables.map do |model|
        model.capitalize.singularize.camelize
      end
    end

    # Get submit key to redirect, only [:create, :update]
    def redirect(object, commit)
      if commit.key?('_save')
        redirect_to([:admin, object], notice: actions_messages(object))
      elsif commit.key?('_add_other')
        redirect_to(
          send("new_admin_#{underscore(object)}_path"),
          notice: actions_messages(object)
        )
      end
    end

    def redefine_ids(ids)
      is_admin = controller_path.include?('admin')
      klass =  is_admin ? controller_name : controller_path

      ids.delete('[]').split(',').select do |id|
        id if klass.classify.constantize.exists? id
      end
    end

    # Check whether the user has permission to delete
    # each of the selected objects
    def can_multiple_destroy
      is_admin = controller_path.include?('admin')
      klass = is_admin ? controller_name : controller_path

      redefine_ids(params[:multiple_ids]).each do |id|
        authorize klass.classify.constantize.find(id)
      end
    end
  end
end
