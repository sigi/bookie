class ScoreBoard

  attr_reader :results

  delegate :[], :to => :results

  def initialize(bets, scorer = ExactScore)
    @results_by_user = {}
    @results = []
    scores = {}

    User.includes(:specialbet).all.each do |u|
      scores[u] = {
        :score => calc_bonus(u), :submitted => 0, :average => 0.0, :change => [0, 0, 0, 0],
        :wrong => 0, :tendency => 0, :correct => 0, :open => 0, :undef => 0
      }
    end

    bets.each do |b|
      score = scorer.score(b)
      scores[b.user][:score] += score.points
      scores[b.user][score.direction] += 1
      scores[b.user][:submitted] += 1 if b.result.played?
      # wird in der letzten Iteration korrekt zugewiesen:
      scores[b.user][:change] << score.points
    end

    scores_ary = scores.sort { |a,b|
      # bei Punktgleichheit nach Name sortieren
      if a[1][:score] != b[1][:score]
        b[1][:score] <=> a[1][:score]
      else
        a[0].real_name.casecmp(b[0].real_name)
      end
    }

    # erster Platz hat immer Rang 1
    scores_ary[0] << (rank=1)
    entry = scores_ary[0][1]
    entry[:average] = entry[:score].to_f / entry[:submitted].to_f unless entry[:submitted] == 0

    (1...scores_ary.length).each { |i|
      entry, last_entry = scores_ary[i][1], scores_ary[i-1][1]
      # naechster Rang bei negativer Punktdifferenz
      rank = i+1 if entry[:score] < last_entry[:score]
      scores_ary[i] << rank
      entry[:average] = entry[:score].to_f / entry[:submitted].to_f unless entry[:submitted] == 0
    } unless scores_ary.length == 1

    @results = scores_ary.collect do |s|
      { :user => s[0], :rank => s[2] }.merge( s[1] )
    end
    @results.each {|result| @results_by_user[ result[:user] ] = result}
  end

  def score_for(user)
    @results_by_user[user].try(:[], :score)
  end

  def rank_for(user)
    @results_by_user[user].try(:[], :rank)
  end

  def calc_bonus(user)
    return 0 if user.specialbet.open?
    bonus = 0
    bonus += if user.specialbet.tournament_winner.name == 'Italien'
               20
             else
               0
             end
    bonus += if user.specialbet.german_progression == 2
               10
             else
               0
             end
    bonus
  end

end
