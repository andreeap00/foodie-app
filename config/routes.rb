Rails.application.routes.draw do
  get '/home', to: 'pages#home', as: :home
  get '/about', to: 'pages#about', as: :about
  get '/service', to: 'pages#service', as: :service
  get '/blog', to: 'pages#blog', as: :blog
  get '/contact', to: 'pages#contact', as: :contact
  get '/help', to: 'pages#help', as: :help

  get 'pages', to: 'pages#home', as: :filtered_products
  get 'pages/sort/:order', to: 'pages#home', as: :sorted_products
  get '/signup', to: 'users#new', as: :signup
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  get '/orders/:id', to: 'orders#show', as: 'order'

  resources :users 
  resources :orders do
    post 'add_to_order/:product_id', on: :member, action: :add_to_order, as: :add_to_order
    delete 'remove_from_order/:product_id', on: :member, to: 'orders#remove_from_order', as: :remove_from_order
    match :purchase, on: :member, via: [:patch, :get]
  end
  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
    patch 'dashboard/mark_as_handled/:order_id', to: 'dashboard#mark_as_handled', as: :mark_as_handled
    patch 'dashboard/mark_as_delivered/:order_id', to: 'dashboard#mark_as_delivered', as: :mark_as_delivered
    resources :products
  end
  resources :products do
    delete :archive, to: 'products#archive', on: :member
  end

  root "pages#home"

  namespace :api do
    namespace :v1 do
      get '/home', to: 'pages#home', as: :home
      get 'pages', to: 'pages#home', as: :filtered_products
      get 'pages/sort/:order', to: 'pages#home', as: :sorted_products
      get '/signup', to: 'users#new', as: :signup
      post '/signup', to: 'users#create'
      get '/login', to: 'sessions#new'
      post '/login', to: 'sessions#create'
      delete '/logout', to: 'sessions#destroy'
      get '/orders/:id', to: 'orders#show', as: 'order'

      resources :users
      resources :orders do
        post 'add_to_order/:product_id', on: :member, action: :add_to_order, as: :add_to_order
        delete 'remove_from_order/:product_id', on: :member, to: 'orders#remove_from_order', as: :remove_from_order
        match :purchase, on: :member, via: [:patch, :get]
      end
      namespace :admin do
        get 'dashboard', to: 'dashboard#index'
        patch 'dashboard/mark_as_handled/:order_id', to: 'dashboard#mark_as_handled', as: :mark_as_handled
        patch 'dashboard/mark_as_delivered/:order_id', to: 'dashboard#mark_as_delivered', as: :mark_as_delivered
        resources :products
        get 'display_users', to: 'display_users#index'
        resources :display_users
        resources :users
      end
      resources :products do
        delete :archive, to: 'products#archive', on: :member
      end
      root "pages#home"
    end
  end
end
