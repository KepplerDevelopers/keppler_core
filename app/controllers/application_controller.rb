# ApplicationControlller -> Controller base this application
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  layout :layout_by_resource
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :paginator_params
  before_filter :set_setting
  before_action :can_multiple_destroy, only: [:destroy_multiple]
  include PublicActivity::StoreController
  include ApplicationHelper

  rescue_from CanCan::AccessDenied do |exception|
    exception.default_message =
      case exception.action
      when :index
        t('keppler.messages.not_authorized_page')
      else
        t('keppler.messages.not_authorized_action')
      end
    redirect_to not_authorized_path, flash: { message: exception.message }
  end

  def paginator_params
    puts params[:search].blank?
    @query = params[:search] unless params[:search].blank?
    @current_page = params[:page] unless params[:page].blank?
  end

  private

  def redefine_ids(ids)
    ids.delete('[]').split(',').select do |id|
      id if controller_path.classify.constantize.exists? id
    end
  end

  # Check whether the user has permission to delete each of the selected objects
  def can_multiple_destroy
    redefine_ids(params[:multiple_ids]).each do |id|
      authorize! :destroy, controller_path.classify.constantize.find(id)
    end
  end

  def get_history(model)
    if current_user.has_role? :admin
      @activities = PublicActivity::Activity.where(
        trackable_type: model.to_s
      ).order('created_at desc').limit(50)
    else
      @activities = PublicActivity::Activity.where(
        "trackable_type = #{model} and owner_id=#{current_user.id}"
      ).order('created_at desc').limit(50)
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:name, :email, :password, :password_confirmation)
    end
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:name, :email, :password, :password_confirmation,
               :current_password)
    end
  end

  def layout_by_resource
    if devise_controller?
      'admin/application'
    else
      'application'
    end
  end

  def set_setting
    @setting = Setting.first
  end

  # Get submit key to redirect, only [:create, :update]
  def redirect(object, commit)
    if commit.key?('_save')
      redirect_to(object, notice: actions_messages(object))
    elsif commit.key?('_add_other')
      redirect_to(
        send("new_#{underscore(object)}_path"),
        notice: actions_messages(object)
      )
    end
  end
end
