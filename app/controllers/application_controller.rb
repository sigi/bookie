class ApplicationController < ActionController::Base

  layout 'bookie'

  helper :all
  protect_from_forgery

  helper_method :current_user_session, :current_user

  before_action :require_user, :setup_scoreboard, :set_query_user

protected

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session&.user
  end

  def require_user
    unless current_user
      store_location
      redirect_to new_user_session_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      redirect_to root_url
      return false
    end
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def require_admin
    unless current_user.admin
      flash[:notice] = "Restricted area."
      redirect_to root_url
      false
    end
  end

  def setup_scoreboard
    @score_board = Bet.get_scores
    @hof = HallOfFame.new(@score_board)
  end

  def set_query_user
    if params[:uid]
      @query_user = User.find_by_id( params[:uid] )
    else
      @query_user = current_user
    end
  end

  def parse_count( value, default = 4 )
    count = value.to_i
    if count < 1 then default else count end
  end

end
