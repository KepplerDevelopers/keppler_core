KepplerContactUs::Engine.routes.draw do
  namespace :admin do
    scope :contact_us, as: :contact_us do
      resources :messages do
        get '(page/:page)', action: :index, on: :collection, as: ''
        get '/clone', action: :clone
        post '/upload', action: :upload
        get '/download', action: :download
        get '/favorite', action: :favorite
        get '/reply', action: :reply
        get '/share', action: :share
        patch '/send', action: :send_message
        # post '/create', action: :create
        post '/sort', action: :sort, on: :collection
        get '/reload', action: :reload, on: :collection
        get '/sent', action: :sent, on: :collection
        get '/read', action: :read, on: :collection
        get '/unread', action: :unread, on: :collection
        get '/favorites', action: :favorites, on: :collection
        get '/settings', action: :settings, on: :collection
        delete '(page/:page)/destroy_multiple', action: :destroy_multiple, on: :collection
      end

    end
  end
end
