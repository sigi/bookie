class Team < ActiveRecord::Migration
  def self.up
    create_table :teams do |t|
      t.string :name, :null => false
    end
  end

  def self.down
    drop_table :teams
  end
end
