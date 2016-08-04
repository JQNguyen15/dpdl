class NumPlayerGamesChannel < ApplicationCable::Channel  
  def subscribed
    stream_from 'numplayergames'
  end
end