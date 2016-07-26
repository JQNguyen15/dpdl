class GamesController < ApplicationController

	def index
	end

	# user creates game
	def create
		@game = Game.new
		current_user.in_game = true
		@game.host = current_user.nickname
		@game.players = "#{@game.players} #{current_user.nickname}"
		@game.save
	end

	# user cancels a game
	def destroy 
    Game.where(:host => current_user.nickname, :started => false).destroy_all
	end

	private

end
