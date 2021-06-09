class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.text :comment, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
