Rails.application.routes.draw do
  get 'status', to: 'pages#status', as: :status
  get 'cancelled', to: 'pages#cancelled', as: :cancelled
  get 'stats', to: 'pages#stats', as: :stats
  devise_for :users

  resources :users
  resources :sources
  resources :disturbances, only: [:index, :show, :edit, :update]
  resources :audits
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "disturbances#index"
end
