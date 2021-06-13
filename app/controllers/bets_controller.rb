require 'result'

class BetsController < ApplicationController

  def index
    @bets = Bet
              .includes(match: [:team1, :team2, :division])
              .where(user: @query_user)
              .order('matches.date ASC')
    @title = "Alle Begegnungen"
  end

  def last
    @bets = Bet
              .includes(:match)
              .references(:matches)
              .where('matches.date <= ? AND bets.user_id = ?',
                     Time.now.utc, @query_user.id)
              .order('matches.date DESC')
              .limit(parse_count params[:id])
    @title = "Vergangene Begegnungen"
    render :action => 'index'
  end

  def next
    @bets = Bet
              .includes(:match)
              .references(:matches)
              .where('matches.date > ? AND bets.user_id = ?',
                     Time.now.utc, @query_user.id)
              .order('matches.date ASC')
              .limit(parse_count params[:id])
    @title = "Kommende Begegnungen"
    render :action => 'index'
  end

  def bets_for_match
    @bets = Bet
              .includes(:user)
              .where('bets.match_id = ?', params[:id])
              .order('user.real_name')

    bets_hsh = Hash.new
    bets.each do |b|
      bets_hsh[b.result] ||= []
      bets_hsh[b.result] << b
    end

     @bets = bets_hsh.sort do |a,b|
       cmp = b[1][0].score <=> a[1][0].score
       if cmp == 0
         cmp = a[0] <=> b[0]
       end
       cmp
     end

    render :partial => 'bets_for_match'
  end

  def division
    @division = Division.find( params[:id] )
    @bets = Bet
              .includes(:match)
              .where(match: { division: @division }, user: @query_user)
              .order('match.date ASC')
    @title = @division.name
    render :action => 'index'
  end

  # 'update' action from a PUT request to '/bets'
  # 'bets[]' hash is generated in the form via fields_for 'bets[]'
  def update
    err = false

    params[:bets].each do |id, r|
      bet = Bet.find(id)
      # Only open bets may be changed.
      # Admins may change closed bets, but not their own.
      if (current_user.admin and bet.user_id != current_user.id) ||
        (bet.open? and bet.user_id == current_user.id)
        bet.result = Result.new(r[:r1], r[:r2])
        err = true unless bet.valid? # set this flag if any bet is invalid
        bet.save
      end
    end

    flash[:notice] = err && "Fehler beim speichern." || "Tipps gespeichert."
    redirect_to bets_url
  end

  def scoreboard
  end

end
