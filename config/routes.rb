Rails.application.routes.draw do
  root to: 'games#index'
  resource :games
  match '/auth/:provider/callback', to: 'sessions#create', via: :all
  delete '/logout', to: 'sessions#destroy', as: :logout
  get '/create', to: 'games#create'
  get '/cancel', to: 'games#destroy'
  get '/join_game', to: 'games#join_game'
  get '/start', to: 'games#start_game'
  get '/vote_radiant', to: 'games#vote_radiant'
  get '/vote_dire', to: 'games#vote_dire'
end
