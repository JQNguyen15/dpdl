class Game < ActiveRecord::Base
  validate :check_max_players
  #TODO
  #refactor
  after_initialize :set_attr

  def set_attr
    @defaultInitialMean = 25.0
    @beta = @defaultInitialMean / 6.0
    @drawProbability = 0.00
    @dynamicsFactor = @defaultInitialMean / 300.00
    @initialStandardDeviation = @defaultInitialMean / 3.0
    @betaSquared = @beta * @beta
    @drawMargin = 0
    @c = 0
    @epsilon = 1e-20
    @tuaSquared = @dynamicsFactor * @dynamicsFactor
    @w = 0.0
    @v = 0.0
  end

  def check_max_players
    if self.players.count > 10
      errors.add(:players, "max players of 10")
    end
  end

  def make_teams
    teams = self.players.combination(5).to_a
    self.match_quality = 0.0
    self.save

    teams.each do |teamA|
      teamB = self.players - teamA

      # array of the rating of each player
      teamARatings = []
      teamBRatings = []

      # std deviations of each player
      teamASTD = []
      teamBSTD = []

      teamA.each do |player|
        aPlayer = User.find_by(id: player)
        teamARatings << aPlayer.skill
        teamASTD << aPlayer.doubt
      end

      teamB.each do |player|
        aPlayer = User.find_by(id: player)
        teamBRatings << aPlayer.skill
        teamBSTD << aPlayer.doubt
      end

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
        self.save
      end

    end # end for each team
  end # end definition

  def calc_stakes
    # array of the rating of each player
    teamARatings = []
    teamBRatings = []

    # std deviations of each player
    teamASTD = []
    teamBSTD = []

    self.radint.each do |player|
      aPlayer = User.find_by(id: player)
      teamARatings << aPlayer.skill
      teamASTD << aPlayer.doubt
    end

    self.dire.each do |player|
      aPlayer = User.find_by(id: player)
      teamBRatings << aPlayer.skill
      teamBSTD << aPlayer.doubt
    end

    # sums up the values of the ratings
    teamAMeanSum = teamARatings.inject(0, :+)
    teamBMeanSum = teamBRatings.inject(0, :+)

    # square then add up std devs
    teamASTD.map! { |num| num ** 2}
    teamBSTD.map! { |num| num ** 2}

    teamASTDSum = teamASTD.inject(0, :+)
    teamBSTDSum = teamBSTD.inject(0, :+)

    totalPlayers = 10

    @c = Math.sqrt( teamASTDSum + teamBSTDSum + (totalPlayers * @betaSquared))
    self.save
  end

  def get_stakes_for_outcome
    winnerRatings = []
    loserRatings = []
    if self.winner == "radiant"
      self.radint.each do |player|
        aPlayer = User.find_by(id: player)
        winnerRatings << aPlayer.skill
      end
      self.dire.each do |player|
        aPlayer = User.find_by(id: player)
        loserRatings << aPlayer.skill
      end
    else
      self.radint.each do |player|
        aPlayer = User.find_by(id: player)
        loserRatings << aPlayer.skill
      end
      self.dire.each do |player|
        aPlayer = User.find_by(id: player)
        winnerRatings << aPlayer.skill
      end
    end
    winnerMeanSum = winnerRatings.inject(0, :+)
    loserMeanSum = loserRatings.inject(0, :+)

    meanDelta = winnerMeanSum - loserMeanSum
    @v = VExceedsMargin(meanDelta, @drawMargin, @c)
    @w = WExceedsMargin(meanDelta, @drawMargin, @c)
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

  def calc_winner_ratings
    rankMultiplier = 1
    if self.winner == "radiant"
      teamWinner = self.radint
    else
      teamWinner = self.dire
    end

    teamWinner.each do |players|
      player = User.find_by(id: players)
      meanMultiplier = ((player.doubt ** 2) + @tuaSquared) / @c
      stdDevMultiplier = ((player.doubt ** 2) + @tuaSquared) / (@c ** 2)
      playerMeanDelta = meanMultiplier * @v * rankMultiplier
      newMean = player.skill + playerMeanDelta

      newSTD = Math.sqrt(( (player.doubt ** 2) + @tuaSquared ) * ( 1 - (@w * stdDevMultiplier)))
      player.doubt = newSTD
      player.skill = newMean
      player.save
    end
    self.save
  end

  def calc_loser_ratings
    rankMultiplier = -1
    if self.loser == "radiant"
      teamLoser = self.radint
    else
      teamLoser = self.dire
    end

    teamLoser.each do |players|
      player = User.find_by(id: players)
      meanMultiplier = ((player.doubt ** 2) + @tuaSquared) / @c
      stdDevMultiplier = ((player.doubt ** 2) + @tuaSquared) / (@c ** 2)
      playerMeanDelta = meanMultiplier * @v * rankMultiplier
      newMean = player.skill + playerMeanDelta

      newSTD = Math.sqrt(( (player.doubt ** 2) + @tuaSquared ) * ( 1 - (@w * stdDevMultiplier)))
      player.doubt = newSTD
      player.skill = newMean
      player.save
    end
    self.save
  end

end
