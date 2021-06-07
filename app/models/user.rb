class User < ActiveRecord::Base

  acts_as_authentic do |c|
    c.crypto_provider = ::Authlogic::CryptoProviders::SCrypt
  end

  validates :email,
            format: {
              with: /@/,
              message: "muss eine E-Mail-Adresse sein."
            },
            length: { maximum: 100 },
            uniqueness: {
              case_sensitive: false,
              if: :will_save_change_to_email?
            }

  validates :password,
            confirmation: { if: :require_password? },
            length: {
              minimum: 3,
              if: :require_password?
            }
  validates :password_confirmation,
            length: {
              minimum: 3,
              if: :require_password?
            }

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
    Specialbet.create( :user => self )
  end

  def update_prizes
    Prize.jackpot(true)
  end

end
