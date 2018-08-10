require_dependency "keppler_frontend/application_controller"

module KepplerFrontend
  class App::FrontendController < App::AppController
    layout 'layouts/keppler_frontend/app/layouts/application'
    # begin keppler
    def keppler
    end
    # end keppler
  end
end
