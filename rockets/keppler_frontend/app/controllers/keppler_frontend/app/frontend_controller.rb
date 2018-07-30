require_dependency "keppler_frontend/application_controller"

module KepplerFrontend
  class App::FrontendController < App::AppController
    layout 'layouts/keppler_frontend/app/layouts/application'
    # begin friend
    def friend
      @views = View.all.select { |v| v unless v.name.eql?('keppler') }
    end
    # end friend
    # begin index
    def index
      # Insert ruby code...
    end
    # end index
    # begin keppler
    def keppler
    end
    # end keppler
  end
end
