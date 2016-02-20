module Admin
  # AdminController
  class AdminController < ApplicationController
    layout 'admin/layouts/application'
    before_filter :authenticate_user!
    load_and_authorize_resource
    before_filter :paginator_params
    before_filter :set_setting
    before_action :can_multiple_destroy, only: [:destroy_multiple]

    def paginator_params
      @query = params[:search] unless params[:search].blank?
      @current_page = params[:page] unless params[:page].blank?
    end

    def set_setting
      @setting = Setting.first
    end

    private

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
      ids.delete('[]').split(',').select do |id|
        id if controller_name.classify.constantize.exists? id
      end
    end

    # Check whether the user has permission to delete
    # each of the selected objects
    def can_multiple_destroy
      redefine_ids(params[:multiple_ids]).each do |id|
        authorize! :destroy, controller_name.classify.constantize.find(id)
      end
    end
  end
end
