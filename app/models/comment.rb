class Comment < ActiveRecord::Base

  attr_accessible :user, :text

  belongs_to :user
  validates_presence_of :text

  def to_s
    text
  end

end
