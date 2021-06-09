class AddWageringToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :wagering, :boolean, :default => true
  end
end
