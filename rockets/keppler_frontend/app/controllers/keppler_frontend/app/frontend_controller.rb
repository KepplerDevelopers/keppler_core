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
    # begin other_name
    def other_name
      # Insert ruby code...
    end
    # end other_name
    # begin other_name
    def other_name
      # Insert ruby code...
    end
    # end other_name
    # begin other_name
    def other_name
      # Insert ruby code...
    end
    # end other_name
    # begin other_name
    def other_name
      # Insert ruby code...
    end
    # end other_name

    # begin keppler
    def keppler
    end
    # end keppler

    private
    # begin callback user_authenticate
    def user_authenticate
      redirect_to '/' unless user_signed_in?
    end
    # end callback user_authenticate
  end
end
