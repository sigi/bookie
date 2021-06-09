# vim: fileencoding=utf-8
class CommentsController < ApplicationController

  def list
    @comments = Comment
                  .includes(:user)
                  .page(params[:page])
                  .order('comments.created_at DESC')
    #@vote = Vote.find( :first, :conditions => [ 'user_id = ?', @current_user.id ] )
    #if @vote.nil? then @vote = Vote.create( :option => 0, :user => @current_user ) end
  end

  def create
    comment = Comment.new( :user => @current_user,
                           :text => params[ :comment ][ 'text' ] )
    if comment.save
      flash[:notice] = 'Dein Beitrag wurde hinzugefügt.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    edit
    if @comment.update_attributes( params[:comment] )
      flash[:notice] = "Dein Beitrag wurde geändert."
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def vote
    @vote = Vote.find( :first, :conditions =>
                       [ 'id = ? and user_id = ?', params[:id], current_user.id ] )
    if @vote.update_attributes( :option => params[:vote][:option] )
      flash[:note] = "Deine Stimme wurde geändert."
    else
      flash[:note] = "Fehler beim Abstimmen."
    end
    redirect_to :action => 'list'
  end

end
