class Specialbet < ActiveRecord::Base

  belongs_to :user
  belongs_to :tournament_winner, :class_name => 'Team'

  def open?
    first_match = Match
                    .order('date ASC')
                    .first
    first_match && 5.minutes.from_now < first_match.date
  end

end
