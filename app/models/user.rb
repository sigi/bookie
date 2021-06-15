class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :validatable,
         :trackable

  has_many :bets, :dependent => :delete_all
  has_many :comments, :dependent => :delete_all
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
    Specialbet.create(user: self, tournament_winner: Team.first)
  end

end
