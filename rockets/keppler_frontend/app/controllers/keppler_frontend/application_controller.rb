module KepplerFrontend
  class ApplicationController < App::AppController
    protect_from_forgery with: :exception
    before_action :user_signed_in?
    before_action :set_admin_locale

    def user_signed_in?
      return if current_user
      redirect_to '/alert/403'
    end

    def only_development
      redirect_to '/admin' if Rails.env.eql?('production')
    end

    def set_admin_locale
      if controller_path.include?('admin')
        I18n.locale = Appearance.first.language || I18n.default_locale
      end
    end
  end
end
