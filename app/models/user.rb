class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable

  has_many :bets, :dependent => :delete_all
  has_many :comments, :dependent => :delete_all
  has_one  :specialbet, :dependent => :destroy

  after_create :create_bets
  after_create :create_specialbet

  after_create  :update_prizes
  after_destroy :update_prizes
  after_update  :update_prizes

private

  def create_bets
    Match.all.each do |m|
      Bet.create( :user => self, :match => m )
    end
  end

  def create_specialbet
    Specialbet.create(user: self, tournament_winner: Team.first)
  end

  def update_prizes
    Prize.jackpot(true)
  end

end
