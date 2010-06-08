class HallOfFame

  attr_reader :results

  delegate :[], :to => :results

  def initialize(score_board)
    @score_board = score_board.results
    @results = {}
    return if @score_board.empty?

    [ :correct, :wrong ] .each do |c|
      @results[c] = hof_extract(c)
    end
    gn_award = @score_board.max do |a,b|
      a[:tendency] + a[:correct] <=> b[:tendency] + b[:correct]
    end
    @results[:tendency] = @score_board.find_all do |s|
      s[:tendency] + s[:correct] == gn_award[:tendency] + gn_award[:correct]
    end
  end

private

  def hof_extract(criterion)
    pts = (@score_board.max { |a,b| a[criterion] <=> b[criterion] })[criterion]
    @score_board.find_all { |s| s[criterion] == pts }
  end

end
