Rails.application.routes.draw do
  get "log_out" => "signins#destroy"
  get "log_in" => "signins#new"
  get 'sign_up' => "users#new"
  root "contexts#index"
  resources :contexts
  resources :users, :path => '' do
    resources :questions
  end
  resources :signins

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
