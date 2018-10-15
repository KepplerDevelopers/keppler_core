module KepplerFrontend
  module App::FrontendHelper
    # begin devise_login
    def devise_login(hash = {})
      render 'keppler_frontend/app/partials/devise_login', hash: hash
    end
    # end devise_login
  end
end
