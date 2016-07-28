class GamesController < ApplicationController
	before_action :logged_in, only: [:create, :destroy, :join_game]
	
	def index
	end

	# user creates game
	def create
		if !current_user.in_game
			@game = Game.new
			user_join
			@game.host = current_user.id
			add_player_to_game(@game, current_user)
			@game.save
		end
	end

	# user cancels a game
	def destroy 
		@game = Game.find_by(id: params[:gameid])
		if @game 
			if @game.host == current_user.id
				@game.players.each do |player|
					@aplayer = User.find_by(id: player)
					user_leave(@aplayer)
				end
				@game.destroy
			else
				@game.players.delete current_user.id
				@game.save
				user_leave(current_user)
			end
			redirect_to root_url
		end
	end

	# a user wants to join
	def join_game
		if !current_user.in_game
			@game = Game.find_by(id: params[:gameid])
			if @game
				user_join
				add_player_to_game(@game, current_user)
			end
		end
	end

	private

		# user is joining a game
		def user_join
			current_user.in_game = true
			current_user.save
		end

		# user is leaving a game
		def user_leave(aUser)
			aUser.in_game = false
			aUser.save
		end

		def add_player_to_game(aGame, aPlayer)
			aGame.players << aPlayer.id
			aGame.save
		end

end
