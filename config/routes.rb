Rails.application.routes.draw do
  get "log_out" => "signins#destroy"
  get "log_in" => "signins#index"
  get 'sign_up' => "users#new"

  root "signins#index"

  resources :users, :path => '' do
    resources :contexts
  end
  resources :signins

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
