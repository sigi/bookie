class Specialbet < ActiveRecord::Migration
  def self.up
    create_table :specialbets do |t|
      t.integer :special1_id, :null => false, :default => 1
      t.string  :special2
      t.integer :special3_id, :null => false, :default => 1
      t.integer :special4_id, :null => false, :default => 1
      t.integer :special5_id, :null => false, :default => 1
      t.integer :special6_id, :null => false, :default => 1
      t.string  :special7
      t.integer :user_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :specialbets
  end
end
