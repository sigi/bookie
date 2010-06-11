class AddPaymentReceivedToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :payment_received, :boolean, :default => false
  end

  def self.down
    remove_column :users, :payment_received
  end
end
