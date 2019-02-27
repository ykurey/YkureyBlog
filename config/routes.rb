Rails.application.routes.draw do
  get 'sign_up' => "users#new"
  # get 'users/log_in'
  # get 'users/log_out'
  root "contexts#index"
  get 'contexts/index' => "contexts#index"
  resources :contexts
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
