KepplerLanguages::Engine.routes.draw do
  namespace :admin do
    scope :locales, as: :languages do
      resources :fields do
        get '(page/:page)', action: :index, on: :collection, as: ''
        get '/clone', action: 'clone'
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

      resources :languages do
        get '(page/:page)', action: :index, on: :collection, as: ''
        delete '/destroy_field/:field_id', action: :destroy_field, as: :destroy_field
        get '/clone', action: 'clone'
        post '/sort', action: :sort, on: :collection
        post '/upload', action: 'upload', as: 'upload'
        get '/download', action: 'download', as: 'download'
        get '/add_fields', action: 'add_fields', as: 'add_fields'
        post '/create_fields', action: 'create_fields', as: 'create_fields'
        post '/toggle', action: 'toggle', as: 'toggle'
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
