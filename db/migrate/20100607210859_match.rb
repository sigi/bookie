class CreateMatches < ActiveRecord::Migration[6.0]
  def change
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
end
