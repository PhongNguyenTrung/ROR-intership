Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :users
  post '/signup', to: 'users#signup'
  post '/login', to: 'authentication#login'
  get '/current_user', to: 'users#get_current_user'
  # mount API::Base => '/'
end
