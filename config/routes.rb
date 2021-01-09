Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '/chatroom', to: 'chatroom#index'
  post '/chatroom/post_message', to: 'chatroom#post_message'

end
