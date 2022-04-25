Rails.application.routes.draw do
  devise_for :users

  resources :users
  resources :sources
  resources :disturbances
  resources :audits
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "disturbances#index"
end
