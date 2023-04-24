Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  
  resources :users
  post '/signup', to: 'users#signup'
  post '/login', to: 'authentication#login'
  get '/current_user', to: 'users#current_user'
  # mount User::API => '/'
end
