class ApplicationController < ActionController::Base

  helper :all
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!

  #before_action :setup_scoreboard, :set_query_user

protected

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

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:real_name])
  end

end
