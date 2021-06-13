class SpecialbetsController < ApplicationController

  def show
    user = User.find(params[:id]) # view provides 'id' of @query_user
    @specialbet = Specialbet
                 .includes(:tournament_winner)
                 .where(user: user)
                 .first
  end

  def update
    @specialbet = Specialbet.find(params[:id])
    if (@specialbet.open? && @specialbet.user_id == current_user.id) ||
      (current_user.admin && @specialbet.user_id != current_user.id)
      if @specialbet.update(specialbet_params)
        flash[:notice] = "Die Sondertipps wurden gespeichert."
      else
        flash[:notice] = "Fehler beim Speichern."
      end
    else
      flash[:notice] = "Fehler beim Speichern."
    end
    render action: 'show'
  end

  private

  def specialbet_params
    params.require(:specialbet).permit(:tournament_winner_id, :german_progression)
  end

end
