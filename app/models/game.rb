class Game < ActiveRecord::Base
  validate :check_max_players
  attr_accessor :defaultInitialMean, :beta, :drawProbability, :initialMean,
                :dynamicsFactor, :initialStandardDeviation

  def defaultInitialMean
    @defaultInitialMean || 25.0
  end              

  def beta
    @beta || defaultInitialMean / 6.0
  end

  def dynamicsFactor
    @dynamicsFactor || defaultInitialMean / 300.0
  end

  def initialStandardDeviation
    @initialStandardDeviation / defaultInitialMean / 3.0
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
      betaSquared = beta * beta

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

      sqrtPart = Math.sqrt((10 * betaSquared) / (10 * betaSquared + teamASTDSum + teamBSTDSum))
      puts sqrtPart
      expPart = Math.exp((-1 * diffMeanSum) / (2 * (10 * betaSquared + teamASTDSum + teamBSTDSum) ))
      puts expPart
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

  end

end
