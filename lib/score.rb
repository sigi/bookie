class Score

  SCORES = {
    :correct => 3,
    :tendency => 1,
    :difference => 1.5,
    :wrong => 0,
    :open => 0,
    :undef => 0
  }

  attr_reader :direction, :diff

  def self.score(bet)
    new(bet.match.result, bet.result)
  end

  def initialize( actual, bet )
    @direction = calc_direction( actual, bet )
    @diff = ( actual.diff - bet.diff ).abs
  end

  def points
    SCORES[ @direction ]
  end

  def <=>( other )
    if @direction == other.direction
      if @direction == :tendency then other.diff <=> @diff
      else 0 end
    else
      self.points <=> other.points
    end
  end

  protected

  def calc_direction( result, bet )
    return :open if not bet.played?
    return :undef if not result.played?
    return :correct if result == bet
    return :tendency if result.diff == bet.diff or result.diff * bet.diff > 0
    return :wrong
  end

end
