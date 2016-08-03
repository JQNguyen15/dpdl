class GamesChannel < ApplicationCable::Channel  
  def subscribed
    stream_from 'games'
  end
end