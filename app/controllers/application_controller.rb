class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  layout :layout_by_resource
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :get_paginator_params
  before_action :can_multiple_destroy, only: [:destroy_multiple]
  include PublicActivity::StoreController
  
  rescue_from CanCan::AccessDenied do |exception|
    exception.default_message = exception.action.eql?(:index) ? "No estás autorizado para acceder a esta página" : "No estás autorizado para realizar esta acción"
    redirect_to not_authorized_path, flash: { message: exception.message }
  end

  def get_paginator_params
    @query = (params[:search] and !params[:search].blank?) ? params[:search] : nil
    @current_page = (params[:page] and !params[:page].blank?) ? params[:page] : nil
  end

  private

  def redefine_ids(ids)
    ids.delete("[]").split(",").select { |id| id if controller_path.classify.constantize.exists? id }
  end
  
  # verificar si el usuario tiene permisos para eliminar cada uno de los objects seleccionados
  def can_multiple_destroy
    redefine_ids(params[:multiple_ids]).each do |id|
      authorize! :destroy, controller_path.classify.constantize.find(id)
    end
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

end
