class Game < ActiveRecord::Base
  validate :check_max_players

  def check_max_players
    if self.players.count > 10
      errors.add(:players, "max players of 10")
    end
  end

  def make_teams

  end
end
