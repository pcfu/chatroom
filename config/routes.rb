Rails.application.routes.draw do
  root to: 'static#homepage'

  get 'login', to: 'static#login'

  get 'register', to: 'static#register'
  post 'register', to: 'users#create'

  get '/chatroom', to: 'chatroom#index'
  post '/chatroom/post_message', to: 'chatroom#post_message'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
