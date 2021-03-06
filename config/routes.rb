Rails.application.routes.draw do
  root to: 'static#homepage'

  get     '/register',  to: 'users#new'
  post    '/register',  to: 'users#create'
  get     '/login',     to: 'sessions#new'
  post    '/login',     to: 'sessions#create'
  delete  '/logout',    to: 'sessions#destroy'

  get     '/chat',  to: 'chat#index'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
