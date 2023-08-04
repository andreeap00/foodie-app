Rails.application.routes.draw do
  get "/home", to: "pages#home", as: :home
  get "/about", to: "pages#about", as: :about
  get "/service", to: "pages#service", as: :service
  get "/blog", to: "pages#blog", as: :blog
  get "/contact", to: "pages#contact", as: :contact
  get "/help", to: "pages#help", as: :help

  get 'pages/:category', to: 'pages#home', as: :filtered_products
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :products
  #root "products#index"
  root "pages#home"
end
