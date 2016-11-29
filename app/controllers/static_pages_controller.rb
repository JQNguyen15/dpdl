class StaticPagesController < ApplicationController
  def leaderboard
    @users = User.order(skill: :desc)
  end
end
