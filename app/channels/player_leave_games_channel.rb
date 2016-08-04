class PlayerLeaveGamesChannel < ApplicationCable::Channel  
  def subscribed
    stream_from 'playerleavegames'
  end
end