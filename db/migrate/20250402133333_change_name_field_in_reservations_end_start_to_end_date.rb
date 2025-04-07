class ChangeNameFieldInReservationsEndStartToEndDate < ActiveRecord::Migration[8.0]
  def change
    rename_column :reservations, :end_start, :end_date
  end
end
