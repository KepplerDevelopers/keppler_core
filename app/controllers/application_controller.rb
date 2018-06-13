# frozen_string_literal: true

# ApplicationControlller -> Controller base this application
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include Pundit
  include PublicActivity::StoreController
  include AdminHelper
  include DeviseParams

  layout :layout_by_resource
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :appearance
  before_action :set_apparience_colors
  before_action :set_sidebar
  before_action :set_modules
  skip_around_action :set_locale_from_url

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def class_exists?(klass)
    defined?(klass) && klass.is_a?(Class)
  end

  def redirect_to_index(_objects_path)
    redirect_to objects_path(page: @current_page.to_i.pred, search: @query)
  end

  def nothing_in_first_page?(objects)
    !objects.first_page? && objects.size.zero?
  end

  def respond_to_formats(objects)
    respond_to do |format|
      format.html
      format.csv { send_data objects.to_csv }
      format.xls { send_data objects.to_xls }
      format.json { render json: objects }
    end
  end

  def user_not_authorized
    flash[:alert] = t('keppler.messages.not_authorized_action')
    redirect_to(request.referrer || root_path)
  end

  # block access dashboard
  def dashboard_access
    roles = Role.all.map(&:name)
    return if !user_signed_in? || roles.include?(current_user.rol)
    raise CanCan::AccessDenied.new(
      t('keppler.messages.not_authorized_page'), :index, :dashboard
    )
  end

  def set_sidebar
    @sidebar = YAML.load_file(
      "#{Rails.root}/config/menu.yml"
    ).values.each(&:symbolize_keys!)
    modules = Dir[File.join("#{Rails.root}/rockets", '*')]
    modules.each do |m|
      module_menu = YAML.load_file(
        "#{m}/config/menu.yml"
      ).values.each(&:symbolize_keys!)
      @sidebar[0] = @sidebar[0].merge(module_menu[0])
    end
  end

  def set_modules
    @modules = YAML.load_file(
      "#{Rails.root}/config/permissions.yml"
    ).values.each(&:symbolize_keys!)
    modules = Dir[File.join("#{Rails.root}/rockets", '*')]
    modules.each do |m|
      module_name = YAML.load_file(
        "#{m}/config/permissions.yml"
      ).values
      if !module_name.first.nil?
        module_name.each(&:symbolize_keys!)
        @modules[0] = @modules[0].merge(module_name[0])
      end
    end
  end

  def appearance
    @appearance = Setting.first.appearance
  end

  def set_apparience_colors
    @color = appearance_service.set_color
  end

  def get_history(model)
    @activities = PublicActivity::Activity.where(
      trackable_type: model.to_s
    ).order('created_at desc').limit(50)
  end

  protected

  def appearance_service
    Admin::AppearanceService.new
  end

  def add_plugins_permissions(modules)
    modules.each do |m|
      module_name = YAML.load_file(
        "#{m}/config/permissions.yml"
      ).values
      next if module_name.first.nil?
      module_name.each(&:symbolize_keys!)
      @modules[0] = @modules[0].merge(module_name[0])
    end
  end

  def layout_by_resource
    'admin/layouts/application' if devise_controller?
  end
end
