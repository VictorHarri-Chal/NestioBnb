class ChangePriceFieldAccommodationToFloat < ActiveRecord::Migration[8.0]
  def change
    change_column :accommodations, :price, :float
  end
end
