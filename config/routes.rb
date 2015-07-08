Rails.application.routes.draw do

  root to: 'frontend#index'

  devise_for :users, skip: KepplerConfiguration.skip_module_devise

  resources :admin, only: :index do
  	get 'dashboard', action: :dashboard, on: :collection, as: :dashboard
  end

  get 'admin/users/refresh',  to: 'users#refresh', as: :user_refresh
  
  scope :admin do
  	resources :users do 
      get '(page/:page)', action: :index, on: :collection, as: ''
      delete '/destroy_multiple', action: :destroy_multiple, on: :collection, as: :destroy_multiple
    end
  end


  #errors
  match '/403', to: 'errors#not_authorized', via: :all, as: :not_authorized
  match '/404', to: 'errors#not_found', via: :all
  match '/422', to: 'errors#unprocessable', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all

end
