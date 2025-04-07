class CreateQuestions < ActiveRecord::Migration[8.0]
  def change
    create_table :questions do |t|
      t.references :user, null: false, foreign_key: true
      t.text :user_question
      t.text :ai_answer

      t.timestamps
    end
  end
end
