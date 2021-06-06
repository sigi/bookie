class Bet < ActiveRecord::Base

  attr_accessible :result1, :result2, :user, :match

  belongs_to :user
  belongs_to :match, :include => :division

  validates_numericality_of :result1, :result2, :only_integer => true

  composed_of( :result, :class_name => 'Result',
               :mapping => [ [ :result1, :r1 ],
                             [ :result2, :r2 ] ] )

  def score(scorer = ExactScore)
    @score ||= scorer.score(self)
  end

  def r1
    result.r1
  end

  def r2
    result.r2
  end

  def closed?
    match.date <= 5.minutes.from_now
  end

  def open?
    !closed?
  end

  def self.get_scores(scorer = ExactScore)
    bets = find( :all, :include => [ :match, :user ],
                 :conditions => [ 'matches.date <= ? and matches.result1 * matches.result2 >= 0', Time.now.utc ],
                 :order => 'matches.date asc' )
    ScoreBoard.new(bets, scorer)
  end

end
