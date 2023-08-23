Rails.application.routes.draw do
  get '/about', to: 'pages#about', as: :about
  get '/service', to: 'pages#service', as: :service
  get '/blog', to: 'pages#blog', as: :blog
  get '/contact', to: 'pages#contact', as: :contact
  get '/help', to: 'pages#help', as: :help

  namespace :api do
    namespace :v1 do
      get '/home', to: 'pages#home', as: :home
      get 'pages', to: 'pages#home', as: :filtered_products
      get 'pages/sort/:order', to: 'pages#home', as: :sorted_products
      get '/signup', to: 'users#new', as: :signup
      get '/login', to: 'sessions#new'
      post '/login', to: 'sessions#create'
      get '/logout', to: 'sessions#destroy'
      get '/orders/:id', to: 'orders#show', as: 'order'

      resources :users, only: [:show]
      # resources :users, only: [:new, :create, :show, :create, :update, :destroy]
      resources :sessions, only: [:create, :destroy]
      resources :orders, only: [:show, :create, :update, :destroy] do
        post 'add_to_order/:product_id', on: :member, action: :add_to_order, as: :add_to_order
        delete 'remove_from_order/:product_id', on: :member, to: 'orders#remove_from_order', as: :remove_from_order
        match :purchase, on: :member, via: [:patch, :get]
      end

      namespace :admin do
        get 'dashboard', to: 'dashboard#index'
        patch 'dashboard/mark_as_handled/:order_id', to: 'dashboard#mark_as_handled', as: :mark_as_handled
        patch 'dashboard/mark_as_delivered/:order_id', to: 'dashboard#mark_as_delivered', as: :mark_as_delivered
        resources :products, only: [:show, :create, :update, :destroy]
      end
      resources :products, only: [:index, :show]
      resources :products, only: [:index, :show] do
        delete :archive, on: :member, to: 'products#archive'
      end
      root "pages#home"
    end
  end

  get '/*path' => 'application#index', constraints: ->(req) { req.format.html? }
end
