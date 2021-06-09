class Comment < ActiveRecord::Base

  belongs_to :user
  validates_presence_of :text

  self.per_page = 10

  def to_s
    text
  end

end
