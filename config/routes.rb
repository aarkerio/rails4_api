Rails.application.routes.draw do
  resources :customers

  get '/' => 'site#index', :as => 'site_index'

  namespace :v1, defaults: {format: :json} do
    post  '/users/update/' => 'users#update_user', as: 'users_update'
    post  '/users/create' => 'users#create_user', as: 'users_create'
    get   '/users/getinfo(/:guid)' => 'users#index', as: 'users_index'
    get   '/users/delete/(/:guid)' => 'users#delete', as: 'users_delete'
    get   '/users/getguid/' => 'users#get_guid', as: 'users_getguid'
    get   '/users/createtoken/' => 'users#create_token'
    post  '/users/subscriptions(/:guid)' => 'users#subscriptions', as: 'subscriptions'
  end

  root to: 'site#index'

end
