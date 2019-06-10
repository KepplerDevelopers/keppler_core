# ApplicationControlller -> Controller base this application
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include MailerConfig
  layout :layout_by_resource
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :appearance, :set_apparience_colors, :set_modules,
                :set_sidebar_menu, :set_languages, :set_admin_locale,
                :git_info, :set_mailer_settings, :set_settings_options

  skip_around_action :set_locale_from_url
  include Pundit
  include AdminHelper
  include ApplicationHelper
  include PublicActivity::StoreController
  helper KepplerLanguages::LanguagesHelper
  helper KepplerCapsules::CapsulesHelper
  helper KepplerGaDashboard::Admin::DashboardHelper

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  # rescue_from Faraday::ConnectionFailed do |error|
  #   redirect_to main_app.admin_users_path, notice: "Sin conexión a internet"
  # end

  private

  def set_settings_options
    @settings_options = %w[configuration basic_information
                          email_setting google_analytics_setting
                          social_accounts]

    @settings_options.insert(1, 'appearance') if Rails.env == 'development'
  end

  def class_exists?(klass)
    defined?(klass) && klass.is_a?(Class)
  end

  def git_info
    @git = Admin::GitHandler.new
  end

  def appearance
    @setting = Setting.includes(:appearance, :social_account).first
    @appearance = @setting.appearance
    Time.zone = @setting.appearance.time_zone
  end

  def set_apparience_colors
    variables_file = File.readlines(style_file)
    @color = ""
    variables_file.each { |line| @color = line[15..21] if line.include?('$keppler-color') }
  end

  def style_file
    "#{Rails.root}/app/assets/stylesheets/admin/utils/_variables.scss"
  end

  def set_setting
    @setting = Setting.first
  end

  def user_not_authorized
    flash[:alert] = t('keppler.messages.not_authorized_action')
    redirect_to not_authorized_path
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

  def set_sidebar_menu
    @sidebar_menu = Admin::Sidebar::Menu.new(current_user).items
    @sidebar_menu = @sidebar_menu.select { |sm| sm.model.nil? || can?(sm.model).index? }
  end

  def set_modules
    @modules = YAML.load_file(
      "#{Rails.root}/config/permissions.yml"
    ).values.each(&:symbolize_keys!)
    modules = Dir[File.join("#{Rails.root}/rockets", '*')]
    modules.each do |m|
      if File.file?("#{m}/config/permissions.yml")
        module_menu = YAML.load_file(
          "#{m}/config/permissions.yml"
        ).values
        unless module_menu.first.nil?
          @modules[0] = @modules[0].merge(module_menu[0])
        end
      end
    end
  end

  def set_admin_locale
    I18n.default_locale = Appearance.first.language || :en
    if controller_path.include?('admin')
      I18n.locale = Appearance.first.language || I18n.default_locale
    end
  end

  def set_languages
    languages = KepplerLanguages::Language.all.map { |l| l.name }
    @languages = languages.push('es', 'en')

    I18n.available_locales = @languages
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :password, :password_confirmation])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :email, :password, :password_confirmation])
  end

  def layout_by_resource
    'admin/layouts/application' if devise_controller?
  end

end
