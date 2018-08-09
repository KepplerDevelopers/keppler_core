module KepplerCapsules
  class ApplicationController < ::ApplicationController
    protect_from_forgery with: :exception
    before_action :user_signed_in?   

    def user_signed_in?
      return if current_user
      redirect_to main_app.new_user_session_path
    end
  end
end
