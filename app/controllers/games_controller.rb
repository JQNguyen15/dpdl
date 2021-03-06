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
      @host = User.find_by(id: current_user.id)
      ActionCable.server.broadcast 'games',
        action: 'create',
        game: @game,
        host: @host
    end
    redirect_to root_url
  end

  # user cancels a game
  def destroy
    @game = Game.find_by(id: params[:gameid])
    if @game && logged_in
      if @game.host == current_user.id
        remove_all_players_from_game(@game)
        @game.destroy
        ActionCable.server.broadcast 'games',
          action: 'destroy',
          gameid: @game.id
      else
        @game.players.delete current_user.id
        @game.save
        user_leave(current_user)
        # need 2 arrays here 1 for player nicknames, 1 for mmr
        @playersmmrs = []
        @playersnicks = []
        @game.players.each { |player|
          @aplayer = User.find_by(id: player)
          @playersmmrs << @aplayer.skill
          @playersnicks << @aplayer.nickname
        }
        ActionCable.server.broadcast 'games',
          action: 'leave',
          gameid: @game.id,
          gameplayers: @playersnicks,
          gameskill: @playersmmrs
          update_num_players(@game)
      end
      redirect_to root_url
    end
  end

  # a user wants to join
  def join_game
    if logged_in
      @game = Game.find_by(id: params[:gameid])
      if @game && @game.players.count < 10
        user_join
        add_player_to_game(@game, current_user)
        ActionCable.server.broadcast 'games',
          action: 'join',
          playername: current_user.nickname,
          playerskill: current_user.skill,
          gameid: @game.id
        update_num_players(@game)
      end
    end
    redirect_to root_url
  end

  def start_game
    if logged_in
      @game = Game.find_by(id: params[:gameid])
      if @game.players.count == 10 && @game.host == current_user.id
        @game.make_teams
        @game.started = true
        # give all players a vote
        @game.players.each { |player|
          @aplayer = User.find_by(id: player)
          @aplayer.has_vote = true
          @aplayer.save
        }
        @game.save
        ActionCable.server.broadcast 'games',
          action: 'destroy'
      end
    end
    redirect_to root_url
  end

  def vote
    if logged_in
      if current_user.has_vote == true
        current_user.has_vote = false
        current_user.save
        @game = Game.find_by(id: params[:gameid])
        if @game
          case params[:team]
            when "radiant"
              @game.rad_votes += 1
              @game.save
            when "dire"
              @game.dire_votes += 1
              @game.save
            when "draw"
              @game.draw_votes += 1
              @game.save
          end
          # TODO: Refactor
          if @game.rad_votes >= 6 && @game.finished == false && @game.started == true
            @game.winner = "radiant"
            @game.loser = "dire"
            @game.finished = true
            @game.started = false
            @game.save
            remove_all_players_from_game(@game)
          elsif @game.dire_votes >= 6 && @game.finished == false && @game.started == true
            @game.winner = "dire"
            @game.loser = "radiant"
            @game.finished = true
            @game.started = false
            @game.save
            remove_all_players_from_game(@game)
          elsif @game.draw_votes >= 6 && @game.finished == false && @game.started == true
            @game.finished = true
            @game.started = false
            @game.save
            remove_all_players_from_game(@game)
            ActionCable.server.broadcast 'games',
              action: 'destroy'
            return
          end

          if @game.finished == true && @game.started == false
            @game.calc_stakes
            @game.get_stakes_for_outcome
            @game.calc_winner_ratings
            @game.calc_loser_ratings
            @game.save
            ActionCable.server.broadcast 'games',
              action: 'destroy'
          end # end check votes
        end # end if game
      end # end current user has vote
    end # end logged in
    redirect_to root_url
  end # end def

  private

    def remove_all_players_from_game(game)
      @game.players.each { |player|
        @aplayer = User.lock.find(player)
        @aplayer.has_vote = false
        @aplayer.in_game = false
        @aplayer.save
      }
    end

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

    def update_num_players(game)
      ActionCable.server.broadcast 'games',
        action: 'updateNumberOfPlayers',
        game: game
    end

end
