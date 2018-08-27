module KepplerLanguages
  class ApplicationController < ::ApplicationController
    protect_from_forgery with: :exception
    before_action :user_signed_in?
    before_action :set_languages

    def user_signed_in?
      return if current_user
      redirect_to main_app.new_user_session_path
    end

    def set_languages
      @languages = YAML.load_file(
        "#{Rails.root}/rockets/keppler_languages/config/locales.yml"
      ).values.each(&:symbolize_keys!)
    end
  end
end
