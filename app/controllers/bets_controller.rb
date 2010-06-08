require 'result'

class BetsController < ApplicationController

  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def index
    list
    render :action => 'list'
  end

  def list
    @bets = Bet.find( :all, :include => :match,
                      :conditions => [ 'bets.user_id = ?', @query_user.id ],
                      :order => 'matches.date asc' )
    @title = "Alle Begegnungen"
  end

  def last
    @bets = Bet.find( :all, :limit => parse_count( params[:id] ),
                      :conditions => [ 'matches.date <= ? and bets.user_id = ?',
                                       Time.now.utc, @query_user.id ],
                      :order => 'matches.date desc', :include => :match )
    @title = "Vergangene Begegnungen"
    render :action => 'list'
  end

  def next
    @bets = Bet.find( :all, :limit => parse_count( params[:id] ),
                      :conditions => [ 'matches.date > ? and bets.user_id = ?',
                                       Time.now.utc, @query_user.id ],
                      :order => 'matches.date asc', :include => :match )
    @title = "Kommende Begegnungen"
    render :action => 'list'
  end

  def bets_for_match
    bets = Bet.find( :all, :include => :user,
                      :conditions => [ 'bets.match_id = ?', params[:id] ],
                      :order => 'users.real_name' )

    bets_hsh = Hash.new
    bets.each do |b|
      bets_hsh[b.result] ||= []
      bets_hsh[b.result] << b
    end

     @bets = bets_hsh.sort do |a,b|
       cmp = b[1][0].score <=> a[1][0].score
       if cmp == 0 then
         cmp = a[0] <=> b[0]
       end
       cmp
     end

    render :partial => 'bets_for_match'
  end

  def division
    @division = Division.find( params[:id] )
    @bets = Bet.find( :all, :conditions => [ 'matches.division_id = ? and bets.user_id = ?',
                                             params[:id], @query_user.id ],
                      :order => 'matches.date asc', :include => :match )
    @title = @division.name
    render :action => 'list'
  end

  def special
    @special = Specialbet.find( :first, :conditions => [ 'user_id = ?', @query_user.id ],
                                :include => [ :special1, :special3, :special4, :special5, :special6 ] )
    @special ||= Specialbet.create( :user => @query_user )
  end

  def update_special
    @special = Specialbet.find( params[:id] )
    if( ( @special.open? && @special.user_id == current_user.id ) ||
        ( current_user.admin && @special.user_id != current_user.id ) )
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
      if( ( current_user.admin and bet.user_id != current_user.id ) or 
          ( bet.open? and bet.user_id == current_user.id ) ) then
        bet.result = Result.new( r[:r1], r[:r2] )
        err = true unless bet.valid?
        bet.save
      end
    end

    flash[:notice] = if err == true then "Fehler beim Speichern." else "Tipps gespeichert." end
    redirect_to :back
  end

  def scoreboard
  end

end
