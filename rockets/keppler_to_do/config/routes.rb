KepplerToDo::Engine.routes.draw do
  namespace :admin do
    scope :to_do, as: :to_do do
      resources :tasks do
        post '/sort', action: :sort, on: :collection
        get '(page/:page)', action: :index, on: :collection, as: ''
        get '/clone', action: 'clone'
        post '/upload', action: 'upload', as: :upload
        get '/reload', action: :reload, on: :collection
        delete '/destroy_multiple', action: :destroy_multiple, on: :collection
      end

    end
  end
end
