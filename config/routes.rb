Rails.application.routes.draw do
   get '/briefing', to: 'app/front#briefing', as: :app_briefing
   get '/webdesing', to: 'app/front#webdesing', as: :app_webdesing
   get '/index', to: 'app/front#index', as: :app_index
   get '/success_ej', to: 'app/front#success_ej', as: :app_success_ej
   get '/success', to: 'app/front#success', as: :app_success
   get '/services', to: 'app/front#services', as: :app_services
   get '/digital', to: 'app/front#digital', as: :app_digital
   get '/search', to: 'app/front#search', as: :app_search
   get '/aboutus', to: 'app/front#aboutus', as: :app_aboutus
   get '/branding', to: 'app/front#branding', as: :app_branding
   get '/blog', to: 'app/front#blog', as: :app_blog

  root to: 'app/front#index'
  get '/test_mailer', to: 'app/front#test_mailer', as: :test_mailer

  devise_for :users, skip: KepplerConfiguration.skip_module_devise

  namespace :admin do

    root to: 'admin#root'

    resources :scaffolds do
      get '(page/:page)', action: :index, on: :collection, as: ''
      get '/clone', action: 'clone'
      post '/import', action: 'import', as: 'import'
      delete(
        action: :destroy_multiple,
        on: :collection,
        as: :destroy_multiple
      )
    end

    resources :customizes do
      get '(page/:page)', action: :index, on: :collection, as: ''
      get '/clone', action: 'clone'
      post '/install_default', action: 'install_default'
      delete(
        action: :destroy_multiple,
        on: :collection,
        as: :destroy_multiple
      )
    end

    resources :users do
      get '(page/:page)', action: :index, on: :collection, as: ''
      post '/upload_avatar', action: :change_avatar
      delete(
        '/destroy_multiple',
        action: :destroy_multiple,
        on: :collection,
        as: :destroy_multiple
      )
    end

    resources :meta_tags do
      get '(page/:page)', action: :index, on: :collection, as: ''
      delete(
        '/destroy_multiple',
        action: :destroy_multiple,
        on: :collection,
        as: :destroy_multiple
      )
    end

    resources :google_adwords do
      get '(page/:page)', action: :index, on: :collection, as: ''
      delete(
        '/destroy_multiple',
        action: :destroy_multiple,
        on: :collection,
        as: :destroy_multiple
      )
    end

    resources :scripts do
      get '(page/:page)', action: :index, on: :collection, as: ''
      delete(
        '/destroy_multiple',
        action: :destroy_multiple,
        on: :collection,
        as: :destroy_multiple
      )
    end

    resources :settings, only: [] do
      collection do
        get '/:config', to: 'settings#edit', as: ''
        put '/:config', to: 'settings#update', as: 'update'
        put '/:config/appearance_default', to: 'settings#appearance_default', as: 'appearance_default'
      end
    end
  end

  # Errors routes
  match '/403', to: 'errors#not_authorized', via: :all, as: :not_authorized
  match '/404', to: 'errors#not_found', via: :all
  match '/422', to: 'errors#unprocessable', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all

  # Dashboard route engine
  mount KepplerGaDashboard::Engine, at: 'admin/dashboard', as: 'dashboard'

end
