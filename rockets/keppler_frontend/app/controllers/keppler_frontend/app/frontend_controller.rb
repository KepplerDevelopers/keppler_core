require_dependency "keppler_frontend/application_controller"

module KepplerFrontend
  class App::FrontendController < App::AppController
    after_filter :test_callback, only: [:test_index]
    after_action :test_callback, only: [:test_index]
    before_filter :test_callback, only: [:test_index]
    before_action :test_callback, only: [:test_index]
    before_action :test_callback_model, only: [:test_index]
    include FrontsHelper
    layout 'layouts/keppler_frontend/app/layouts/application'
    # begin show
    def show
      # Insert ruby code...
    end
    # end show
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
    # begin callback user_authenticate
    def user_authenticate
      redirect_to '/' unless user_signed_in?
    end
    # end callback user_authenticate
  end
end
