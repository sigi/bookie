class Comment < ActiveRecord::Base

  belongs_to :user
  validates_presence_of :text

  def to_s
    text
  end

end
