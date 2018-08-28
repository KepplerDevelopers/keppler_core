Rails.application.routes.draw do
  mount KepplerFrontend::Engine => "/keppler_frontend"
end
