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

  # resources :products
  resources :users
  root "pages#home"
end
