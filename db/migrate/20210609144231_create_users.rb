class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :real_name, null: false
      t.boolean :admin, null: false, default: false
      t.boolean :wagering, null: false, default: true
      t.boolean :payment_received, null: false, default: false

      t.timestamps
    end
  end
end
