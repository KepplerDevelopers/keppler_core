module KepplerCapsules
  class ApplicationController < ::ApplicationController
    protect_from_forgery with: :exception
    before_action :user_signed_in?   

    def user_signed_in?
      return if current_user
      redirect_to redirect_to '/alert/403'
    end
  end
end
