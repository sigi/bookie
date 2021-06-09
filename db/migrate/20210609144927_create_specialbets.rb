class CreateSpecialbets < ActiveRecord::Migration[6.1]
  def change
    create_table :specialbets do |t|
      t.integer :german_progression, null: false, default: 1
      t.references :tournament_winner, null: false, foreign_key: { to_table: :teams }
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
