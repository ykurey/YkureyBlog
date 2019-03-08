Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  get 'sign_up' => "users#new"
  root "signin#index"
  get 'sign_in' => "signin#index"
  post "sign_in" => "signin#create"
  get "sign_out" => "signin#destroy"

  resources :users, :path => '' do
    resources :contexts
  end



  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
