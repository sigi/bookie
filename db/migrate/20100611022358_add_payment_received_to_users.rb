class AddPaymentReceivedToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :payment_received, :boolean, :default => false
  end
end
