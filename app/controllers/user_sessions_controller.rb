# Taken from Authlogic example application
class UserSessionsController < ApplicationController

  layout 'login'

  before_action :require_no_user, :only => [:new, :create]
  before_action :require_user,    :only => :destroy

  skip_before_action :setup_scoreboard, :set_query_user

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      redirect_back_or_default root_url
    else
      render :action => :new
    end
  end

  def destroy
    current_user_session.destroy
    redirect_back_or_default new_user_session_url
  end

end
