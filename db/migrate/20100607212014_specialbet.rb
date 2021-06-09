class CreateSpecialbets < ActiveRecord::Migration[6.0]
  def change
    create_table :specialbets do |t|
      t.integer :special1_id, :null => false, :default => 1
      t.string  :special2
      t.string  :special3
      t.string  :special4
      t.integer :user_id, :null => false
      t.timestamps
    end
  end
end
