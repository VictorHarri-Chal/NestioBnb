class CreateReservations < ActiveRecord::Migration[8.0]
  def change
    create_table :reservations do |t|
      t.references :occupant, null: false, foreign_key: { to_table: :users }
      t.references :accommodation, null: false, foreign_key: true
      t.string :status
      t.date :start_date
      t.date :end_start

      t.timestamps
    end
  end
end
