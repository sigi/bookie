class Division < ActiveRecord::Migration
  def self.up
    create_table :divisions do |t|
      t.string :name, :null => false
    end
  end

  def self.down
    drop_table :divisions
  end
end
