Rails.application.routes.draw do
  root to: 'games#index'
  resource :games
  match '/auth/:provider/callback', to: 'sessions#create', via: :all
  delete '/logout', to: 'sessions#destroy', as: :logout
  get '/create', to: 'games#create'
  get '/cancel', to: 'games#destroy'
end
