class CreateNotations < ActiveRecord::Migration[8.0]
  def change
    create_table :notations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :accommodation, null: false, foreign_key: true
      t.integer :note
      t.text :comment

      t.timestamps
    end
  end
end
