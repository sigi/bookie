class UsersController < ApplicationController

  before_action :require_admin, :only => [:register_payments]

  skip_before_action :setup_scoreboard, :set_query_user, :only => [:new, :create]

  def new
    @user = User.new
  end

  def create
    params.permit!
    @user = User.create(params[:user])
    if @user
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
    User
      .all
      .update_all(payment_received: false)
    User
      .where(id: params[:payment_received])
      .update_all(payment_received: true)
    flash[:notice] = "Zahlungen aktualisiert."
    redirect_to :controller => "/bets", :action => "scoreboard"
  end

end
