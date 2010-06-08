class Match < ActiveRecord::Migration
  def self.up
    create_table :matches do |t|
      t.integer :result1, :null => false, :default => -1, :limit => 4
      t.integer :result2, :null => false, :default => -1, :limit => 4
      t.datetime :date, :null => false
      t.text :info
      t.integer :team1_id, :null => false
      t.integer :team2_id, :null => false
      t.integer :division_id, :null => false
      t.timestamps
    end
    add_index "matches", ["team1_id"], :name => "team1_id"
    add_index "matches", ["team2_id"], :name => "team2_id"
    add_index "matches", ["division_id"], :name => "division_id"
  end

  def self.down
    remove_index "matches", :name => "team2_id"
    remove_index "matches", :name => "team1_id"
    drop_table :matches
  end
end
