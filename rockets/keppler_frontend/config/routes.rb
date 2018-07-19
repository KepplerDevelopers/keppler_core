KepplerFrontend::Engine.routes.draw do
  get '/andres', to: 'app/frontend#andres', as: :andres
  get '/', to: 'app/frontend#index', as: :index
  root to: 'app/frontend#keppler', as: :keppler
  namespace :admin do
    scope :frontend, as: :frontend do
      resources :views do
        get '(page/:page)', action: :index, on: :collection, as: ''
        get '/clone', action: 'clone'
        get '/editor', action: 'editor'
        post '/editor/save', action: 'editor_save'
        post '/sort', action: :sort, on: :collection
        post '/upload', action: 'upload', as: 'upload'
        get '/download', action: 'download', as: 'download'
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

    end
  end
end
