# vim: fileencoding=utf-8
class MatchesController < ApplicationController

  before_action :require_admin

  def index
    @matches = Match
                 .includes(:division)
                 .all
                 .order('date ASC')
    @title = "Alle Begegnungen"
  end

  def last
    count = parse_count( params[:id] )
    @matches = Match
                 .includes(:division)
                 .where('date <= ?', Time.now.utc)
                 .limit(count)
                 .order('date DESC')
    @title = "Vergangene Begegnungen"
    render :action => 'index'
  end

  def next
    count = parse_count( params[:id] )
    @matches = Match
                 .includes(:division)
                 .where('date > ?', Time.now.utc)
                 .limit(count)
                 .order('date ASC')
    @title = "Kommende Begegnungen"
    render :action => 'index'
  end

  def division
    @division = Division.find(params[:id])
    @matches = Match
                 .includes(:division)
                 .where(division: @division)
                 .order('date ASC')
    @title = @division.name
    render :action => 'index'
  end

  def new
    @match = Match.new
    last_match = Match
                   .order('date DESC')
                   .first
    @match.date = if last_match.nil? then Time.now else last_match.date end
  end

  def create
    params.permit!
    @match = Match.new(params[:match])

    if @match.save
      flash[:notice] = 'Die Begegnung wurde erstellt.'
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  def edit
    @match = Match.find(params[:id])
  end

  def update
    params.permit!
    @match = Match.find(params[:id])
    if @match.update(params[:match])
      flash[:notice] = "Die Daten für die Begegnung '#{@match}' wurden geändert.".html_safe
      # expire_fragment "hof"
      redirect_to :action => 'index'
    else
      render :action => 'edit'
    end
  end

  def destroy
    Match.find(params[:id]).destroy
    redirect_to :action => 'index'
  end

end
