class StaticPagesController < ApplicationController
  def leaderboard
    @users = User.order(skill: :desc)
  end

  def recent_games
    @games = Game.where.not(winner: 'null').order(created_at: :desc).limit(10)
  end
end
