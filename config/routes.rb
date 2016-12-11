Rails.application.routes.draw do
  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'

  root to: 'games#index'
  resource :games
  match '/auth/:provider/callback', to: 'sessions#create', via: :all
  delete '/logout', to: 'sessions#destroy', as: :logout
  get '/create', to: 'games#create'
  get '/cancel', to: 'games#destroy'
  get '/join_game', to: 'games#join_game'
  get '/start', to: 'games#start_game'
  get '/vote_radiant', to: 'games#vote'
  get '/vote_dire', to: 'games#vote'
  get '/vote_draw', to: 'games#vote'
  get '/leaderboard', to: 'static_pages#leaderboard'
  get '/recent_games', to: 'static_pages#recent_games'
end
