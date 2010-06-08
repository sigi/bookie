class User < ActiveRecord::Base

  acts_as_authentic

  has_many :bets,       :dependent => :delete_all
  #has_many :comments,   :dependent => :delete_all
  has_one  :specialbet, :dependent => :destroy

  after_create :create_bets
  after_create :create_specialbet

private

  def create_bets
    Match.all.each do |m|
      Bet.create( :user => self, :match => m )
    end
  end

  def create_specialbet
    Specialbet.create( :user => self )
  end

end
