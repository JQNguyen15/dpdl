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
			if @game && @game.players.count < 10
				user_join
				add_player_to_game(@game, current_user)
			end
		end
	end

	def start_game
		@game = Game.find_by(id: params[:gameid])
		if @game.players.count == 10
			
			@game.make_teams

			@game.started = true
			# give all players a vote
			@game.players.each do |player|
				player.has_vote = true
				player.save
			end
			@game.save            
		end
	end

	def vote_radiant
		current_user.has_vote = false
		current_user.save

		@game = Game.find_by(id: params[:gameid])
		@game.rad_votes += 1
		if @game.rad_votes >= 6
			@game.winner = "radiant"
			@game.loser = "dire"
		end
		@game.calc_stakes
		@game.get_stakes_for_outcome
		@game.calc_winner_ratings
		@game.calc_loser_ratings
		@game.finished = true
		@game.started = false
		@game.save
		user_leave(current_user)
	end

	def vote_dire
		current_user.has_vote = false
		current_user.save

		@game = Game.find_by(id: params[:gameid])
		@game.dire_votes += 1
		if @game.dire_votes >= 6
			@game.winner = "dire"
			@game.loser = "radiant"
		end
		@game.calc_stakes
		@game.get_stakes_for_outcome
		@game.calc_winner_ratings
		@game.calc_loser_ratings
		@game.finished = true
		@game.started = false
		@game.save
		user_leave(current_user)
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
