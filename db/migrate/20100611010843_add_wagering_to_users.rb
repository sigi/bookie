class AddWageringToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :wagering, :boolean, :default => true
  end

  def self.down
    remove_column :users, :wagering
  end
end
