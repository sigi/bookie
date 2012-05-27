# vim: fileencoding=utf-8
class MatchesController < ApplicationController

  before_filter :require_admin

  def index
    list
    render :action => 'list'
  end

  def list
    @matches = Match.find( :all, :include => :division )
    @title = "Alle Begegnungen"
  end

  def last
    count = parse_count( params[:id] )
    @matches = Match.find( :all, :limit => count,
                           :conditions => [ 'date <= ?', Time.now.utc ],
                           :order => 'date desc', :include => :division )
    @title = "Vergangene Begegnungen"
    render :action => 'list'
  end

  def next
    count = parse_count( params[:id] )
    @matches = Match.find( :all, :limit => count,
                           :conditions => [ 'date > ?', Time.now.utc ],
                           :order => 'date asc', :include => :division )
    @title = "Kommende Begegnungen"
    render :action => 'list'
  end

  def division
    @division = Division.find( params[:id] )
    @matches = Match.find( :all, :conditions => [ 'division_id = ?', params[:id] ],
                           :order => 'date asc', :include => :division )
    @title = @division.name
    render :action => 'list'
  end

  def new
    @match = Match.new
    last_match = Match.find( :first, :order => 'date desc' )
    @match.date = if last_match.nil? then Time.now else last_match.date end
  end

  def create
    @match = Match.new(params[:match])

    if @match.save
      flash[:notice] = 'Die Begegnung wurde erstellt.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @match = Match.find(params[:id])
  end

  def update
    @match = Match.find(params[:id])
    if @match.update_attributes(params[:match])
      flash[:notice] = "Die Daten für die Begegnung '#{@match}' wurden geändert."
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def destroy
    Match.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

end
