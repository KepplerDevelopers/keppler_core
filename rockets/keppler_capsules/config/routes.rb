KepplerCapsules::Engine.routes.draw do
  namespace :admin do
    scope :space, as: :capsules do
      #new routes
      resources :capsules do
        delete '/destroy_field/:capsule_field_id', action: :destroy_field, as: :destroy_field
        delete '/destroy_validation/:capsule_validation_id', action: :destroy_validation, as: :destroy_validation
        delete '/destroy_association/:capsule_association_id', action: :destroy_association, as: :destroy_association
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
    end
  end
end
