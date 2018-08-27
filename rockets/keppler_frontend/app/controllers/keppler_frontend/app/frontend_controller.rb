require_dependency "keppler_frontend/application_controller"

module KepplerFrontend
  class App::FrontendController < App::AppController
    # Begin callbacks area (don't delete)
    # End callbacks area (don't delete)
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
    # begin callback client_params
    def client_params
      # Insert ruby code...
    end
    # end callback client_params
    # begin callback set_client_info
    def set_client_info
      # Insert ruby code...
    end
    # end callback set_client_info
  end
end
