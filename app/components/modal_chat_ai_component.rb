# frozen_string_literal: true

class ModalChatAiComponent < ViewComponent::Base
  def initialize(user)
    @user = user

    if user.present?
      @questions = user.questions
      @question = Question.new
    end
  end

  def render?
    @user.present?
  end
end
