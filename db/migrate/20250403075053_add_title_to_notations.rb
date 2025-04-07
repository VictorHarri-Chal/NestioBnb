# frozen_string_literal: true

class AddTitleToNotations < ActiveRecord::Migration[8.0]
  def up
    add_column :notations, :title, :string
    add_column :notations, :description, :text
    remove_column :notations, :comment
  end

  def down
    remove_column :notations, :title
    remove_column :notations, :description
    add_column :notations, :comment, :text
  end
end
