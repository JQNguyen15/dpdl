class DestroyGameChannel < ApplicationCable::Channel  
  def subscribed
    stream_from 'destroygame'
  end
end