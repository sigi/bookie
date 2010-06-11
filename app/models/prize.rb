class Prize

  PROGRESSION = [ 50, 30, 20 ]
  STAKE = 5.0

  attr_reader :rank, :percentage, :amount

  def initialize(rank)
    @rank       = rank
    @percentage = get_percentage
    @amount     = get_prize
  end

  def self.all
    result = []
    PROGRESSION.length.times do |index|
      result << new(index + 1)
    end
    result
  end

  def self.jackpot(refresh = false)
    if refresh || !@jackpot
      @jackpot = User.count(:conditions => {:wagering => true}) * STAKE
    end
    @jackpot
  end

private

  def get_percentage
    if @rank > PROGRESSION.length
      0.0
    else
      PROGRESSION[@rank-1].to_f
    end
  end

  def get_prize
    @percentage / 100.0 * Prize.jackpot
  end

end
