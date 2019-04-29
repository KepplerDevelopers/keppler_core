require_dependency "keppler_frontend/application_controller"

module KepplerFrontend
  class App::FrontendController < App::AppController
    include FrontsHelper
    layout 'layouts/keppler_frontend/app/layouts/application'
  end
end
