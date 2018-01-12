Rails.application.routes.draw do

  root to: 'app/front#index'
  get '/test_mailer', to: 'app/front#test_mailer', as: :test_mailer

  devise_for :users, skip: KepplerConfiguration.skip_module_devise

  namespace :admin do

    root to: 'admin#root'

   resources :galleries do
      get '(page/:page)', action: :index, on: :collection, as: ''
      get '/clone', action: 'clone'
      post '/import', action: 'import', as: 'import'
      delete(
        action: :destroy_multiple,
        on: :collection,
        as: :destroy_multiple
      )
      resources :photos do
        get '(page/:page)', action: :index, on: :collection, as: ''
        get '/clone', action: 'clone'
        post '/import', action: 'import'
        delete(
          action: :destroy_multiple,
          on: :collection,
          as: :destroy_multiple
        )
      end
    end


    # resources :blog do
    #   get '(page/:page)', to: 'blog#index', as: :blog_listing
    #   get ":type/:permalink", to: 'blog#filter', as: :filter
    #   get "category/:category/subcategory/:subcategory", to: 'blog#filter_subcategory', as: :filter_subcategory
    #   get '/:permalink', to: 'blog#show', as: :blog_show_post
    #   resources :categories do
    #     get '(page/:page)', action: :index, on: :collection, as: 'search'
    #     delete '/destroy_multiple', action: :destroy_multiple, on: :collection, as: :destroy_multiple
    #    resources :posts do
    #      get 'find/subcategories', action: :subcategories_of_cagegory, on: :collection
    #      get '(page/:page)', action: :index, on: :collection, as: 'search'
    #      get '/clone', action: 'clone'
    #      delete '/destroy_multiple', action: :destroy_multiple, on: :collection, as: :destroy_multiple
    #    end
    #   end
    # end

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

  # Keppler Contact Us
  mount KepplerContactUs::Engine, :at => '/', as: 'messages'

  # Keppler Blog
  mount KepplerBlog::Engine, :at => '/', as: 'blog'

end
