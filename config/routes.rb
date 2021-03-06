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
  get 'checks', to: 'inventories#show_checks'
  get 'adds', to: 'inventories#show_adds'
  
  resources :order_sheets do
    member do
      get 'arrival'
      post 'arrival', to: 'order_sheets#add'
    end
  end
end
