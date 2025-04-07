# frozen_string_literal: true

class RenameAddress < ActiveRecord::Migration[8.0]
  def change
    rename_column :accommodations, :adress, :address
  end
end
