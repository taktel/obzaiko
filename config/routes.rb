Rails.application.routes.draw do
  root to: 'toppages#index'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  get 'signup', to: 'user#new'
  resources :users, only: [:show, :new, :create]
  
  resources :categories
  
  resources :items, only: [:show, :new, :create, :edit, :update, :destroy]
end
