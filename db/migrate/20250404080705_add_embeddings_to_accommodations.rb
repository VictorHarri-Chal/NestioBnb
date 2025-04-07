class AddEmbeddingsToAccommodations < ActiveRecord::Migration[8.0]
  def change
    add_column :accommodations, :embedding, :vector, limit: 1536
  end
end
