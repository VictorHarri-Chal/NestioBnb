class ChatbotJob < ApplicationJob
  queue_as :default

  def perform(question)
    @question = question

    chatgpt_response = client.chat(
      parameters: {
        model: "gpt-4o-mini",
        messages: questions_formatted_for_openai
      }
    )
    new_content = chatgpt_response.dig("choices", 0, "message", "content")

    question.update(ai_answer: new_content)

    Turbo::StreamsChannel.broadcast_update_to(
      "question_#{@question.id}",
      target: "question_#{@question.id}",
      partial: "questions/question", locals: { question: })
  end

  private

  def client
    @client ||= OpenAI::Client.new
  end

  def questions_formatted_for_openai
    questions = @question.user.questions

    results = []
    
    system_text = "You are an assistant for an e-commerce website. 1. Always say the name of the product. 2. If you don't know the answer, you can say 'I don't know. If you don't have any products at the end of this message, say we don't have that.  Here are the products you should use to answer the user's questions: "
    
    system_text += "\nHere's a list of accommodations that might help answer your question:"
    nearest_accommodations.each do |accommodation|
      system_text += "1. [#{accommodation.title}](#{Rails.application.routes.url_helpers.accommodation_path(accommodation)})"
    end
    
    results << { role: "system", content: system_text }

    questions.each do |question|
      results << { role: "user", content: question.user_question }
      results << { role: "assistant", content: question.ai_answer || "" }
    end

    results
  end

  def nearest_accommodations
    response = client.embeddings(
      parameters: {
        model: "text-embedding-3-small",
        input: @question.user_question
      }
    )

    question_embedding = response["data"][0]["embedding"]

    Accommodation.nearest_neighbors(
      :embedding, question_embedding,
      distance: "euclidean"
    )
  end
end