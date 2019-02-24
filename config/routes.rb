Rails.application.routes.draw do
  root "context#index"
  get 'context/index' => "context#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
