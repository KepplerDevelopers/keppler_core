class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  layout :layout_by_resource
  before_filter :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    exception.default_message = exception.action.eql?(:index) ? "No estás autorizado para acceder a esta página" : "No estás autorizado para realizar esta acción"
    link_back = exception.action.eql?(:index) ? nil : "/admin/#{exception.subject.class.to_s.downcase.pluralize}"

    redirect_to not_authorized_path, flash: { message: exception.message, back: link_back }
  end

  protected
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:name, :email, :password, :password_confirmation)
    end
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:name, :email, :password, :password_confirmation, :current_password)
    end
  end

  def layout_by_resource
    if devise_controller? 
      "admin/application"
    else
      "application"
    end
  end

  private

end
