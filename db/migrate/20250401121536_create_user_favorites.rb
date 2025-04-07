class CreateUserFavorites < ActiveRecord::Migration[8.0]
  def change
    create_table :user_favorites do |t|
      t.references :user, null: false, foreign_key: true
      t.references :accommodation, null: false, foreign_key: true

      t.timestamps
    end
  end
end
