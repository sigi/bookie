class ExactScore < Score

  SCORES = {
    :correct => 20,
    :tendency => 15,
    :wrong => 0,
    :open => 0,
    :undef => 0
  }

  def initialize( actual, bet )
    super( actual, bet )
    @score = calc_score( actual, bet )
  end

  def points() @score end

protected

  def calc_score( actual, bet )
    base_score = SCORES[@direction]

    case @direction
    when :correct
      base_score
    when :tendency
      if actual.diff == 0
        penalty = (actual.r1-bet.r1).abs - 1
        base_score - penalty * 2
      else
        base_score - @diff * 2
      end
    else
      0
    end
  end

end
