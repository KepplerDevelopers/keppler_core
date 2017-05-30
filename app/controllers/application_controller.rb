# ApplicationControlller -> Controller base this application
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  layout :layout_by_resource
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :appearance
  include PublicActivity::StoreController
  include AdminHelper

  rescue_from CanCan::AccessDenied do |exception|
    exception.default_message =
      case exception.action
      when :index
        t('keppler.messages.not_authorized_page')
      else
        t('keppler.messages.not_authorized_action')
      end
    redirect_to main_app.not_authorized_path, flash: {
      message: exception.message
    }
  end

  private

  # block access dashboard
  def dashboard_access
    unless [:admin].include? current_user.rol.to_sym
      raise CanCan::AccessDenied.new(
        t('keppler.messages.not_authorized_page'), :index, :dashboard
      )
    end
  end

  def appearance
    @appearance = Setting.first.appearance
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
    RUBY_VERSION < "2.2.0" ? devise_old : devise_new
  end

  def layout_by_resource
    'admin/layouts/application' if devise_controller?
  end

  def devise_new
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :password, :password_confirmation])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :email, :password, :password_confirmation])
  end

  def devise_old
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:name, :email, :password, :password_confirmation)
    end
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:name, :email, :password, :password_confirmation,
               :current_password)
    end
  end

end
