Rails.application.routes.draw do
  root to: 'toppages#index'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  get 'signup', to: 'user#new'
  resources :users
  
  resources :categories
  resources :vendors, only: [:index, :show, :new, :create, :edit, :update]
  
  resources :items do
    collection { post :import }
  end
  
  resources :inventories, only: [:index, :create, :edit, :update, :destroy]
  get 'check', to: 'inventories#check'
  get 'add', to: 'inventories#add'
  
  resources :order_sheets

end
