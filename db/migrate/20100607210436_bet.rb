class Bet < ActiveRecord::Migration
  def self.up
    create_table :bets do |t|
      t.integer :result1, :null => false, :default => -1, :limit => 4
      t.integer :result2, :null => false, :default => -1, :limit => 4
      t.integer :user_id, :null => false
      t.integer :match_id, :null => false
      t.timestamps
    end
    add_index "bets", ["user_id"], :name => "user_id"
    add_index "bets", ["match_id"], :name => "match_id"
  end

  def self.down
    remove_index "bets", :name => "match_id"
    remove_index "bets", :name => "user_id"
    drop_table :bets
  end
end
