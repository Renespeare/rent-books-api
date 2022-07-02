Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  resources :users, param: :_username
  resources :books, param: :_id
  resources :writers, param: :_id
  resources :writerships, param: :_id
  resources :borrows, param: :_id
  resources :reviews, param: :_id
  resources :book_content, param: :_id
  post '/auth/login', to: 'authentication#login'
  get '/*a', to: 'application#not_found'

end
