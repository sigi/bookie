class CreateBets < ActiveRecord::Migration[6.0]
  def change
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
end
