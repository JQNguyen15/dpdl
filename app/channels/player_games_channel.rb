class PlayerGamesChannel < ApplicationCable::Channel  
  def subscribed
    stream_from 'playergames'
  end
end