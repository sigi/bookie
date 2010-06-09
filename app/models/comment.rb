class Comment < ActiveRecord::Base

  belongs_to :user
  validates_presence_of :text

  def to_s
    self.text.simple_format
  end

end
