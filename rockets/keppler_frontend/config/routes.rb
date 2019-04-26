KepplerFrontend::Engine.routes.draw do
  root to: 'app/frontend#keppler', as: :keppler

  namespace :admin do
    scope :frontend, as: :frontend do
      resources :themes do
        get '(page/:page)', action: :index, on: :collection, as: ''
        get '/clone', action: 'clone'
        post '/sort', action: :sort, on: :collection
        post '/upload', action: 'upload', as: 'upload'
        get '/download', action: 'download', as: 'download'
        get '/show_covers', action: 'show_covers', as: 'show_covers'
        get(
          '/reload',
          action: :reload,
          on: :collection,
        )
        delete(
          '/destroy_multiple',
          action: :destroy_multiple,
          on: :collection,
          as: :destroy_multiple
        )
      end

      get '/views', to: 'views#index', as: 'views'
      post '/views/select_theme', to: 'views#select_theme', as: 'views_select_theme'
      get '/views/refresh', to: 'views#refresh', as: 'views_refresh'
      post '/views/generate', to: 'views#generate', as: 'views_generate'
      delete '/views/remove/:file', to: 'views#remove', as: 'views_remove'

      get '/assets', to: 'multimedia#index', as: 'multimedia'
      post '/assets/upload', to: 'multimedia#upload', as: 'upload_multimedia'
      get '/assets/upload', to: 'multimedia#upload', as: 'show_upload_multimedia'
      delete '/assets/:search/:fileformat', to: 'multimedia#destroy', as: 'destroy_multimedia'
      get '/assets/:search/:fileformat', to: 'multimedia#destroy', as: 'show_destroy_multimedia'

    end
  end
end