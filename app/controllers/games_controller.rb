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
        gameid: @game.id,
        host: @host.nickname,
        hostmmr: @host.skill,
        numPlayers: @game.players.count
    end
    redirect_to root_url
  end

  # user cancels a game
  def destroy
    @game = Game.find_by(id: params[:gameid])
    if @game && logged_in
      if @game.host == current_user.id
        @game.players.each do |player|
          @aplayer = User.find_by(id: player)
          user_leave(@aplayer)
          @aplayer.in_game = false
          @aplayer.save
        end
        @game.destroy
        ActionCable.server.broadcast 'destroygame',
        gameid: @game.id
      else
        @game.players.delete current_user.id
        @game.save
        user_leave(current_user)
        # need 2 arrays here 1 for player nicknames, 1 for mmr
        @playersmmrs = []
        @playersnicks = []
        @game.players.each do |player|
          @aplayer = User.find_by(id: player)
          @playersmmrs << @aplayer.skill
          @playersnicks << @aplayer.nickname
        end
        down = false
        ActionCable.server.broadcast 'playerleavegames',
          gameid: @game.id,
          gameplayers: @playersnicks,
          gameskill: @playersmmrs
          update_num_players(@game.players.count, @game.id, down)
      end
      redirect_to root_url
    end
  end

  # a user wants to join
  def join_game
    if logged_in && current_user.in_game
      flash[:danger] = "Please leave your current game first"
    end
    if !current_user.in_game && logged_in
      @game = Game.find_by(id: params[:gameid])
      if @game && @game.players.count < 10
        user_join
        add_player_to_game(@game, current_user)
        ActionCable.server.broadcast 'playergames',
          playername: current_user.nickname,
          playerskill: current_user.skill,
          gameid: @game.id

        up = true
        update_num_players(@game.players.count,@game.id,up)
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
        @game.players.each do |player|
          @aplayer = User.find_by(id: player)
          @aplayer.has_vote = true
          @aplayer.save
        end
        @game.save
        ActionCable.server.broadcast 'destroygame',
          gameid: @game.id
      end
    end
    redirect_to root_url
  end

  def vote_radiant
    if logged_in
      if current_user.has_vote == true
        current_user.has_vote = false
        current_user.save

        @game = Game.find_by(id: params[:gameid])
        if @game
          @game.rad_votes += 1
          @game.save

          if @game.rad_votes >= 6 && @game.finished == false && @game.started == true
            @game.winner = "radiant"
            @game.loser = "dire"

            @game.calc_stakes
            @game.get_stakes_for_outcome
            @game.calc_winner_ratings
            @game.calc_loser_ratings
            @game.finished = true
            @game.started = false
            @game.save
            @game.players.each do |player|
              @aplayer = User.find_by(id: player)
              @aplayer.has_vote = false
              user_leave(@aplayer)
              @aplayer.in_game = false
              @aplayer.save
            end #end player
            ActionCable.server.broadcast 'destroygame',
              gameid: @game.id
          end # end check votes
        end # end if game
      end # end current user has vote
    end # end logged in
    redirect_to root_url
  end # end def

  def vote_dire
    if logged_in
      if current_user.has_vote == true
        current_user.has_vote = false
        current_user.save

        @game = Game.find_by(id: params[:gameid])
        if @game
          @game.dire_votes += 1
          @game.save

          if @game.dire_votes >= 6 && @game.finished == false && @game.started == true
            @game.winner = "dire"
            @game.loser = "radiant"

            @game.calc_stakes
            @game.get_stakes_for_outcome
            @game.calc_winner_ratings
            @game.calc_loser_ratings
            @game.finished = true
            @game.started = false
            @game.save
            @game.players.each do |player|
              @aplayer = User.find_by(id: player)
              @aplayer.has_vote = false
              user_leave(@aplayer)
              @aplayer.in_game = false
              @aplayer.save
            end #end player
            ActionCable.server.broadcast 'destroygame',
              gameid: @game.id
          end # end check votes
        end # end if game
      end # end current user has vote
    end # end logged in
    redirect_to root_url
  end # end def

  def vote_draw
    if logged_in
      if current_user.has_vote == true
        current_user.has_vote = false
        current_user.save

        @game = Game.find_by(id: params[:gameid])
        if @game
          @game.draw_votes += 1
          @game.save
          if @game.draw_votes >= 6 && @game.finished == false && @game.started == true
            @game.finished = true
            @game.started = false
            @game.save

            @game.players.each do |player|
              @aplayer = User.find_by(id: player)
              @aplayer.has_vote = false
              user_leave(@aplayer)
              @aplayer.in_game = false
              @aplayer.save
            end #end player
            ActionCable.server.broadcast 'destroygame',
              gameid: @game.id
          end
        end
      end
    end
  redirect_to root_url
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

    def update_num_players(numPlayers,gameID,upOrDown)
      ActionCable.server.broadcast 'numplayergames',
        numPlayers: numPlayers,
        gameid: gameID,
        upOrDown: upOrDown
    end

end
