Rails.application.routes.draw do
  get "/home", to: "pages#home"
  get "/about", to: "pages#about"
  get "/service", to: "pages#service"
  get "/blog", to: "pages#blog"
  get "/contact", to: "pages#contact"
  get "/help", to: "pages#help"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :products
  #root "products#index"
  root "pages#home"
end
