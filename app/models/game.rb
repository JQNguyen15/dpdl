class Game < ActiveRecord::Base
  validate :check_max_players
  after_initialize :set_attr

  def set_attr
    @defaultInitialMean = 25.0
    @beta = @defaultInitialMean / 6.0
    @drawProbability = 0.00
    @dynamicsFactor = @defaultInitialMean / 300.00
    @initialStandardDeviation = @defaultInitialMean / 3.0
    @betaSquared = @beta * @beta
    @drawMargin = 0.0
    @epsilon = 1e-20
    @tuaSquared = @dynamicsFactor * @dynamicsFactor
  end

  def check_max_players
    if self.players.count > 10
      errors.add(:players, "max players of 10")
    end
  end

  def get_ratings(team)
    teamRatings = []
    team.each do |player|
      aPlayer = User.find(player)
      teamRatings << aPlayer.skill
    end
    return teamRatings
  end

  def get_std(team)
    teamStd = []
    team.each do |player|
      aPlayer = User.find(player)
      teamStd << aPlayer.doubt
    end
    return teamStd
  end

  def make_teams
    teams = self.players.combination(5).to_a
    self.match_quality = 0.0
    self.save

    teams.each do |teamA|
      teamB = self.players - teamA

      # array of the rating of each player
      teamARatings = get_ratings(teamA)
      teamBRatings = get_ratings(teamB)

      # std deviations of each player
      teamASTD = get_std(teamA)
      teamBSTD = get_std(teamB)

      # sums up the values of the ratings
      teamAMeanSum = teamARatings.inject(0, :+)
      teamBMeanSum = teamBRatings.inject(0, :+)

      # square then add up std devs
      teamASTD.map! { |num| num ** 2}
      teamBSTD.map! { |num| num ** 2}

      teamASTDSum = teamASTD.inject(0, :+)
      teamBSTDSum = teamBSTD.inject(0, :+)

      diffMeanSum = teamAMeanSum - teamBMeanSum
      diffMeanSum = diffMeanSum * diffMeanSum

      sqrtPart = Math.sqrt((10 * @betaSquared) / (10 * @betaSquared + teamASTDSum + teamBSTDSum))
      #puts sqrtPart
      expPart = Math.exp((-1 * diffMeanSum) / (2 * (10 * @betaSquared + teamASTDSum + teamBSTDSum) ))
      #puts expPart
      matchQuality = expPart * sqrtPart

      if matchQuality > self.match_quality
        self.match_quality = matchQuality
        self.radint = teamA
        self.dire = teamB
        self.teamASTDSum = teamASTDSum
        self.teamBSTDSum = teamBSTDSum
        self.teamAMeanSum = teamAMeanSum
        self.teamBMeanSum = teamBMeanSum
        self.radiMmr = self.teamAMeanSum / 5.0
        self.direMmr = self.teamBMeanSum / 5.0
      end
    end # end for each team
    self.save
  end # end definition

  def calc_stakes
    totalPlayers = 10
    self.c = Math.sqrt(self.teamASTDSum + self.teamBSTDSum + (totalPlayers * @betaSquared))
    self.save
  end

  def get_stakes_for_outcome
    winnerRatings = []
    loserRatings = []
    if self.winner == "radiant"
      winnerRatings = get_ratings(self.radint)
      loserRatings = get_ratings(self.dire)
    else
      loserRatings = get_ratings(self.radint)
      winnerRatings = get_ratings(self.dire)
    end
    winnerMeanSum = winnerRatings.inject(0, :+)
    loserMeanSum = loserRatings.inject(0, :+)

    meanDelta = winnerMeanSum - loserMeanSum
    self.v = VExceedsMargin(meanDelta, @drawMargin, self.c)
    self.w = WExceedsMargin(meanDelta, @drawMargin, self.c)
    self.save
  end

  def VExceedsMargin(teamPerformanceDiff, drawMargin, c)
    teamPerformanceDiff /= c
    drawMargin /= c
    d = Distribution::Normal.cdf(teamPerformanceDiff - drawMargin)
    if (d < @epsilon)
      return -teamPerformanceDiff + drawMargin
    end

    return Distribution::Normal.pdf(teamPerformanceDiff - drawMargin) / d
  end

  def WExceedsMargin(teamPerformanceDiff, drawMargin, c)
    teamPerformanceDiff /= c
    drawMargin /= c

    vWin = VExceedsMargin(teamPerformanceDiff,drawMargin,1)

    result = vWin * (vWin + teamPerformanceDiff - drawMargin)

    d = Distribution::Normal.cdf(teamPerformanceDiff - drawMargin)

    if (d < @epsilon)
      if (teamPerformanceDiff < 0.0)
        result = 1.0
      end
      result = 0.0
    end
    return result
  end

  def calc_new_ratings(team, rankMultiplier)
    team.each do |player|
      aPlayer = User.find(player)
      oldSkill = aPlayer.skill
      oldStd = aPlayer.doubt
      meanMultiplier = ((oldStd ** 2) + @tuaSquared) / self.c
      stdDevMultiplier = ((oldStd ** 2) + @tuaSquared) / (self.c ** 2)
      playerMeanDelta = meanMultiplier * self.v * rankMultiplier
      newMean = oldSkill + playerMeanDelta
      newStd = Math.sqrt(
        ((oldStd ** 2) + @tuaSquared) * (1 - (self.w * stdDevMultiplier))
      )
      aPlayer.doubt = newStd
      aPlayer.skill = newMean
      aPlayer.wins += 1
      aPlayer.save
    end
  end

  def calc_winner_ratings
    rankMultiplier = 1
    if self.winner == "radiant"
      teamWinner = self.radint
    else
      teamWinner = self.dire
    end
    calc_new_ratings(teamWinner, rankMultiplier)
    self.save
  end

  def calc_loser_ratings
    rankMultiplier = -1
    if self.loser == "radiant"
      teamLoser = self.radint
    else
      teamLoser = self.dire
    end
    calc_new_ratings(teamLoser, rankMultiplier)
    self.save
  end

end
