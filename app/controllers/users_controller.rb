class UsersController < ApplicationController

  layout 'login', :only => [:new, :create]

  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]
  before_filter :require_admin, :only => [:register_payments]

  skip_before_filter :setup_scoreboard, :set_query_user, :only => [:new, :create]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to root_url
    else
      render :action => :new
    end
  end
  
  def show
    @user = @current_user
  end

  def edit
    @user = @current_user
  end
  
  def update
    @user = @current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end

  def register_payments
    User.update_all( "payment_received = 't'", {:id => params[:payment_received]} )
    redirect_to :controller => "/bets", :action => "scoreboard"
  end

end
