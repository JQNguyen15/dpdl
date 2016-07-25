class GamesController < ApplicationController
	def new
		@game = Game.new
	end

	def create

	end

	def show
		#render "_newgame"
	end

	private
		def game_params
			params.require(:game).permit(:host)
		end

end
