Rails.application.routes.draw do
  resources :customers
   get '/' => 'site#index', :as => 'site_index'

  namespace :v1, defaults: {format: :json} do
    post  '/users/update/' => 'users#update_user', as: 'users_update'
    post  '/users/create' => 'users#create_user', as: 'users_create'
    get   '/users/getinfo(/:user_token)' => 'users#index', as: 'users_index'
    get   '/users/delete/(/:user_token)' => 'users#delete', as: 'users_delete'
    get   '/users/gettoken/' => 'users#get_token', as: 'users_gettoken'
    get   '/users/createtoken/' => 'users#create_token'
    post  '/users/subscriptions(/:user_token)' => 'users#subscriptions', as: 'subscriptions'
  end

  root to: 'site#index'


end
