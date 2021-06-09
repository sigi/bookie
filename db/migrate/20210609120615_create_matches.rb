class CreateMatches < ActiveRecord::Migration[6.1]
  def change
    create_table :matches do |t|
      t.integer :result1, limit: 2, default: -1, null: false
      t.integer :result2, limit: 2, default: -1, null: false
      t.datetime :date, null: false
      t.text :info
      t.references :team1, null: false, foreign_key: { to_table: :teams }
      t.references :team2, null: false, foreign_key: { to_table: :teams }
      t.references :division, null: false, foreign_key: true

      t.timestamps
    end
  end
end
