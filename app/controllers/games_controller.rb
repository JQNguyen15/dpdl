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
		end
	end

	# user cancels a game
	def destroy 
		@game = Game.find_by(id: params[:gameid])
		if @game 
			if @game.host.eql? current_user.id.to_s
				#first set all users in game to false
				@players = @game.players.split
				@players.each do |player|
					@aplayer = User.find_by(id: player)
					user_leave(@aplayer)
				end
				@game.destroy
			else
				# convert to int array, delete the right user, then join and put it back as string
				@players = @game.players.split.map(&:to_i)
				@players.delete current_user.id
				@game.players = @players.map(&:to_s).join(" ")
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

		def user_join
			current_user.in_game = true
			current_user.save
		end

		def user_leave(auser)
			auser.in_game = false
			auser.save
		end

		def add_player_to_game(agame, aplayer)
			agame.players = "#{agame.players} #{aplayer.id}"
			agame.save
		end

end
