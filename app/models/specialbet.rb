class Specialbet < ActiveRecord::Base

  belongs_to :user
  belongs_to :special1, :foreign_key => 'special1_id', :class_name => 'Team'

  def open?
    first_match = Match.find( :first, :order => 'date asc' )
    first_match && 5.minutes.from_now < first_match.date
  end

end
