class Specialbet < ActiveRecord::Base

  attr_accessible :user, :special1, :special2, :special3, :special4,
                  :special5, :special6, :special7

  belongs_to :user
  belongs_to :special1, :foreign_key => 'special1_id', :class_name => 'Team'
  belongs_to :special3, :foreign_key => 'special3_id', :class_name => 'Team'
  belongs_to :special4, :foreign_key => 'special4_id', :class_name => 'Team'
  belongs_to :special5, :foreign_key => 'special5_id', :class_name => 'Team'
  belongs_to :special6, :foreign_key => 'special6_id', :class_name => 'Team'

  def open?
    first_match = Match.find( :first, :order => 'date asc' )
    first_match && 5.minutes.from_now < first_match.date
  end

end
