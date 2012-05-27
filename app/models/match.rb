class Match < ActiveRecord::Base

  attr_accessible :team1_id, :team2_id, :result1, :result2, :division_id, :date, :info

  belongs_to :team1, :foreign_key => "team1_id", :class_name => "Team"
  belongs_to :team2, :foreign_key => "team2_id", :class_name => "Team"
  belongs_to :division
  has_many :bets, :dependent => :delete_all

  after_create :create_bets

  composed_of( :result, :class_name => 'Result',
               :mapping => [ [ :result1, :r1 ],
                             [ :result2, :r2 ] ] )

  validates_numericality_of :result1, :result2, :only_integer => true
  validate :grouping, :valid_opponent, on: :create

  scope :next, lambda { |count| where("date > ?", Time.now.utc).order("date ASC").limit(count) }

  def to_s
    "#{team1.name}&nbsp;&ndash;&nbsp;#{team2.name}".html_safe
  end

  def date_string
    date.strftime( "%d.%m. um %H:%M&nbsp;Uhr" ).html_safe
  end

private

  def valid_opponent
    unless team1.id != team2.id
      errors.add( :base, "Die Mannschaft spielt gegen sich selbst..." )
    end
  end

  def grouping
    count = Match.count( :all,
                         :conditions => [ 'division_id = :div and ' +
                                          '( team1_id = :team1 and team2_id = :team2 ' +
                                          'or team2_id = :team1 and team1_id = :team2 )',
                                          { :div => division.id, :team1 => team1.id, :team2 => team2.id } ] )
    if count > 0
      errors.add( :base, "Diese Paarung existiert bereits in dieser Gruppe (vielleicht in anderer Reihenfolge)." );
    end
  end

  def create_bets
    User.all.each do |u|
      Bet.create( :user => u, :match => self )
    end
  end

end
