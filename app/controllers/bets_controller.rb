require 'result'

class BetsController < ApplicationController

  def index
    list
    render :action => 'list'
  end

  def list
    @bets = Bet
              .includes(:match)
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
    render :action => 'list'
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
    render :action => 'list'
  end

  def bets_for_match
    @bets = Bet
              .includes(:user)
              .where('bets.match_id = ?', params[:id])
              .order('users.real_name')

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
              .order('matches.date ASC')
    @title = @division.name
    render :action => 'list'
  end

  def special
    @special = Specialbet
                 .includes(:tournament_winner)
                 .where(user: @query_user)
                 .first
    @special ||= Specialbet.create(user: @query_user)
  end

  def update_special
    @special = Specialbet.find( params[:id] )
    if (@special.open? && @special.user_id == current_user.id) ||
      (current_user.admin && @special.user_id != current_user.id)
      if @special.update_attributes(params[:special])
        flash[:notice] = "Die Sondertipps wurden gespeichert."
        redirect_to :back
      else
        flash[:notice] = "Fehler beim Speichern."
        render :action => 'special'
      end
    else
      flash[:notice] = "Fehler beim Speichern."
      render :action => 'special'
    end
  end

  def update
    err = false

    params[:bet].each do |id, r|
      bet = Bet.find( id )
      # admin darf fremde Tipps immer aendern, andere duerfen eigene, offene Tipps aendern
      if (current_user.admin and bet.user_id != current_user.id) ||
        (bet.open? and bet.user_id == current_user.id)
        bet.result = Result.new( r[:r1], r[:r2] )
        err = true unless bet.valid?
        bet.save
      end
    end

    flash[:notice] = if err then "Fehler beim Speichern." else "Tipps gespeichert." end
    redirect_to :back
  end

  def scoreboard
  end

end
