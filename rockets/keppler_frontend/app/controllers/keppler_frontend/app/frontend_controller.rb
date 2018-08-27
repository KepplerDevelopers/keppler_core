require_dependency "keppler_frontend/application_controller"

module KepplerFrontend
  class App::FrontendController < App::AppController
    include FrontsHelper
    layout 'layouts/keppler_frontend/app/layouts/application'
    # begin index
    def index
      # Insert ruby code...
    end
    # end index
    # begin keppler
    def keppler
    end
    # end keppler

    private
    # begin callback set_client_info
    def set_client_info
      # Insert ruby code...
    end
    # end callback set_client_info
  end
end
