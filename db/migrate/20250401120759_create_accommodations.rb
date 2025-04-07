class CreateAccommodations < ActiveRecord::Migration[8.0]
  def change
    create_table :accommodations do |t|
      t.string :title
      t.text :description
      t.references :owner, null: false, foreign_key: { to_table: :users }
      t.integer :price
      t.string :adress
      t.float :lat
      t.float :long
      t.string :category

      t.timestamps
    end
  end
end
