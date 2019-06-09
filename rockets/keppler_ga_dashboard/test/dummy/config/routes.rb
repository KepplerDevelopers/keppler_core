Rails.application.routes.draw do
  # mount KepplerGaDashboard::Engine => "/keppler_ga_dashboard"
  mount KepplerGaDashboard::Engine, at: 'admin/dashboard', as: 'dashboard'
end
