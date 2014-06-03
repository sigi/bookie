class Specialbet < ActiveRecord::Migration
  def self.up
    create_table :specialbets do |t|
      t.integer :special1_id, :null => false, :default => 1
      t.string  :special2
      t.string  :special3
      t.string  :special4
      t.integer :user_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :specialbets
  end
end
