# ApplicationControlller -> Controller base this application
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  layout :layout_by_resource
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :appearance
  before_action :set_apparience_colors
  before_action :set_sidebar
  skip_around_action :set_locale_from_url
  include Pundit
  include PublicActivity::StoreController
  include AdminHelper

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  # rescue_from Faraday::ConnectionFailed do |error|
  #   redirect_to main_app.admin_users_path, notice: "Sin conexión a internet"
  # end

  private

  def user_not_authorized
    flash[:alert] = 'No tienes permiso para realizar esa acción'
    redirect_to(request.referrer || root_path)
  end
  # block access dashboard
  def dashboard_access
    roles = Role.all.map {|x| x.name}
    unless !user_signed_in? || roles.include?(current_user.rol)
      raise CanCan::AccessDenied.new(
        t('keppler.messages.not_authorized_page'), :index, :dashboard
      )
    end
  end

  def set_sidebar
    @sidebar = YAML.load_file(
      "#{Rails.root}/config/menu.yml"
    ).values.each(&:symbolize_keys!)
    modules = Dir[File.join("#{Rails.root}/plugins", '*')]
    modules.each do |m|
      module_menu = YAML.load_file(
        "#{m}/config/menu.yml"
      ).values.each(&:symbolize_keys!)
      @sidebar[0] = @sidebar[0].merge(module_menu[0])
    end
  end

  def appearance
    @appearance = Setting.first.appearance
  end

  def set_apparience_colors
    variables_file = File.readlines(style_file)
    @color = ""
    variables_file.each { |line| @color = line[15..21] if line.include?('$keppler-color') }
  end

  def style_file
    "#{Rails.root}/app/assets/stylesheets/admin/utils/_variables.scss"
  end

  def get_history(model)
    @activities = PublicActivity::Activity.where(
      trackable_type: model.to_s
    ).order('created_at desc').limit(50)
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
